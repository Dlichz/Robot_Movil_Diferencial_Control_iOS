//
//  RoverUUIDs.swift
//  DesktopRover
//
//  Created by Francisco David Zárate Vásquez on 17/05/26.
//


import Foundation
import CoreBluetooth
import Combine

// UUIDs (deben coincidir EXACTAMENTE con los del ESP32)
struct RoverUUIDs {
    static let service = CBUUID(string: "6e400001-b5a3-f393-e0a9-e50e24dcca9e")
    static let rx      = CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e") // write
    static let tx      = CBUUID(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e") // notify
}

struct DiscoveredDevice: Identifiable, Equatable {
    let id: UUID
    let peripheral: CBPeripheral
    let name: String
    var rssi: Int
    
    static func == (lhs: DiscoveredDevice, rhs: DiscoveredDevice) -> Bool {
        lhs.id == rhs.id
    }
}

enum ConnectionState: String {
    case poweredOff = "Bluetooth apagado"
    case unauthorized = "Sin permisos"
    case idle = "Listo"
    case scanning = "Escaneando..."
    case connecting = "Conectando..."
    case connected = "Conectado"
    case disconnecting = "Desconectando..."
}

final class BLEManager: NSObject, ObservableObject {
    @Published var state: ConnectionState = .idle
    @Published var devices: [DiscoveredDevice] = []
    @Published var connectedDevice: DiscoveredDevice?
    @Published var receivedMessages: [String] = []
    @Published var currentRSSI: Int = 0
    
    private var central: CBCentralManager!
    private var peripheral: CBPeripheral?
    private var rxCharacteristic: CBCharacteristic?  // para escribir
    private var txCharacteristic: CBCharacteristic?  // para leer notificaciones
    private var rssiTimer: Timer?
    
    override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: .main)
    }
    
    // MARK: - Acciones públicas
    
    func startScan() {
        guard central.state == .poweredOn else { return }
        devices.removeAll()
        state = .scanning
        central.scanForPeripherals(withServices: [RoverUUIDs.service], options: nil)
        
        // Detener escaneo automáticamente a los 10s
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            self?.stopScan()
        }
    }
    
    func stopScan() {
        central.stopScan()
        if state == .scanning { state = .idle }
    }
    
    func connect(_ device: DiscoveredDevice) {
        stopScan()
        state = .connecting
        peripheral = device.peripheral
        peripheral?.delegate = self
        central.connect(device.peripheral, options: nil)
    }
    
    func disconnect() {
        guard let p = peripheral else { return }
        state = .disconnecting
        central.cancelPeripheralConnection(p)
    }
    
    func send(_ command: String) {
        guard let p = peripheral,
              let rx = rxCharacteristic,
              let data = command.data(using: .utf8) else { return }
        
        let type: CBCharacteristicWriteType = rx.properties.contains(.writeWithoutResponse)
            ? .withoutResponse : .withResponse
        p.writeValue(data, for: rx, type: type)
        appendMessage("→ \(command)")
    }
    
    private func appendMessage(_ msg: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        receivedMessages.append("[\(timestamp)] \(msg)")
        if receivedMessages.count > 100 {
            receivedMessages.removeFirst(receivedMessages.count - 100)
        }
    }
    
    private func startRSSIUpdates() {
        rssiTimer?.invalidate()
        rssiTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.peripheral?.readRSSI()
        }
    }
    
    private func stopRSSIUpdates() {
        rssiTimer?.invalidate()
        rssiTimer = nil
    }
}

// MARK: - CBCentralManagerDelegate

extension BLEManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:    state = .idle
        case .poweredOff:   state = .poweredOff
        case .unauthorized: state = .unauthorized
        default:            state = .idle
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        let name = peripheral.name 
            ?? advertisementData[CBAdvertisementDataLocalNameKey] as? String 
            ?? "Sin nombre"
        
        let device = DiscoveredDevice(
            id: peripheral.identifier,
            peripheral: peripheral,
            name: name,
            rssi: RSSI.intValue
        )
        
        if let idx = devices.firstIndex(where: { $0.id == device.id }) {
            devices[idx].rssi = RSSI.intValue
        } else {
            devices.append(device)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        state = .connected
        if let p = peripheral.name {
            connectedDevice = DiscoveredDevice(
                id: peripheral.identifier,
                peripheral: peripheral,
                name: p,
                rssi: 0
            )
        }
        peripheral.discoverServices([RoverUUIDs.service])
        startRSSIUpdates()
        appendMessage("✓ Conectado")
    }
    
    func centralManager(_ central: CBCentralManager, 
                        didDisconnectPeripheral peripheral: CBPeripheral, 
                        error: Error?) {
        state = .idle
        connectedDevice = nil
        rxCharacteristic = nil
        txCharacteristic = nil
        stopRSSIUpdates()
        appendMessage("✗ Desconectado")
    }
    
    func centralManager(_ central: CBCentralManager, 
                        didFailToConnect peripheral: CBPeripheral, 
                        error: Error?) {
        state = .idle
        appendMessage("⚠ Falló conexión: \(error?.localizedDescription ?? "desconocido")")
    }
}

// MARK: - CBPeripheralDelegate

extension BLEManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services where service.uuid == RoverUUIDs.service {
            peripheral.discoverCharacteristics([RoverUUIDs.rx, RoverUUIDs.tx], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, 
                    didDiscoverCharacteristicsFor service: CBService, 
                    error: Error?) {
        guard let chars = service.characteristics else { return }
        for c in chars {
            if c.uuid == RoverUUIDs.rx {
                rxCharacteristic = c
            } else if c.uuid == RoverUUIDs.tx {
                txCharacteristic = c
                peripheral.setNotifyValue(true, for: c)
            }
        }
        appendMessage("✓ Servicios listos")
    }
    
    func peripheral(_ peripheral: CBPeripheral, 
                    didUpdateValueFor characteristic: CBCharacteristic, 
                    error: Error?) {
        guard characteristic.uuid == RoverUUIDs.tx,
              let data = characteristic.value,
              let str = String(data: data, encoding: .utf8) else { return }
        appendMessage("← \(str)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        currentRSSI = RSSI.intValue
    }
}