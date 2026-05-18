//
//  BluetoothManager.swift
//  DesktopRover
//
//  Created by Francisco David Zárate Vásquez on 17/05/26.
//


import Foundation
import CoreBluetooth
import Combine

// Usamos ObservableObject para que la interfaz de SwiftUI se entere cuando cambien las variables
class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // @Published le dice a SwiftUI: "Si esto cambia, redibuja la pantalla"
    @Published var connectionStatus = "Desconectado"
    
    // Aquí guardamos el ESP32 cuando lo encontramos
    var centralManager: CBCentralManager!
    var esp32Peripheral: CBPeripheral?
    
    // Aquí guardamos el canal (característica) para poder escribir el 1 o 0 después
    var targetCharacteristic: CBCharacteristic?
    
    // Los mismos identificadores que pusiste en PlatformIO
    let serviceUUID = CBUUID(string: "4FAFC201-1FB5-459E-8FCC-C5C9C331914B")
    let characteristicUUID = CBUUID(string: "BEB5483E-36E1-4688-B7F5-EA07361B26A8")
    
    override init() {
        super.init()
        // Inicializa el administrador de Bluetooth de iOS
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // PASO 1: iOS nos avisa si el Bluetooth del iPhone está prendido o apagado
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            connectionStatus = "Buscando ESP32..."
            // Empieza a buscar dispositivos que anuncien nuestro SERVICE_UUID
            centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
        } else {
            connectionStatus = "Bluetooth apagado"
        }
    }
    
    // PASO 2: iOS encontró el ESP32 en el aire
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        connectionStatus = "Dispositivo encontrado..."
        centralManager.stopScan() // Dejamos de escanear para no gastar batería
        
        esp32Peripheral = peripheral
        esp32Peripheral?.delegate = self // Ahora este archivo también manejará lo que haga el ESP32
        
        // Nos conectamos formalmente
        centralManager.connect(peripheral, options: nil)
    }
    
    // PASO 3: ¡Ya estamos conectados! Ahora exploramos el ESP32
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectionStatus = "Conectando a servicios..."
        // Buscamos el servicio específico del ESP32
        peripheral.discoverServices([serviceUUID])
    }
    
    // PASO 4: Se encontraron los servicios, ahora buscamos la característica (el canal de datos)
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            // Buscamos la característica dentro de este servicio
            peripheral.discoverCharacteristics([characteristicUUID], for: service)
        }
    }
    
    // PASO 5: Encontramos la característica. Guardamos la referencia para poder usarla.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.uuid == characteristicUUID {
                self.targetCharacteristic = characteristic // <-- GUARDADO
                
                // Le decimos a SwiftUI que ya estamos listos para interactuar
                DispatchQueue.main.async {
                    self.connectionStatus = "¡Conectado!"
                }
            }
        }
    }
    
    // PASO 6: La función que activa el botón. Envía un "1" o un "0"
    func sendLEDCommand(turnOn: Bool) {
        // Verificamos que tengamos conexión y que conozcamos el canal (característica)
        guard let peripheral = esp32Peripheral, let characteristic = targetCharacteristic else { return }
        
        let commandString = turnOn ? "1" : "0"
        
        // Convertimos el texto ("1" o "0") a bytes (Data), que es lo que entiende el Bluetooth
        if let data = commandString.data(using: .utf8) {
            // Enviamos el dato. .withResponse le pide al ESP32 que acuse de recibido
            peripheral.writeValue(data, for: characteristic, type: .withResponse)
        }
    }
    
    // EXTRA: Si el ESP32 se apaga o se aleja, nos damos cuenta aquí
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        DispatchQueue.main.async {
            self.connectionStatus = "Desconectado"
        }
        // Volvemos a escanear automáticamente por si regresa
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }
}
