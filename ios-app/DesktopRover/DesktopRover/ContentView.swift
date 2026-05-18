//
//  ContentView.swift
//  DesktopRover
//
//  Created by Francisco David Zárate Vásquez on 17/05/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var ble: BLEManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                statusBar
                
                if ble.state == .connected {
                    consoleView
                } else {
                    scanView
                }
            }
            .navigationTitle("DesktopRover")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Barra de estado superior
    private var statusBar: some View {
        HStack {
            Circle()
                .fill(statusColor)
                .frame(width: 10, height: 10)
            Text(ble.state.rawValue)
                .font(.subheadline)
            Spacer()
            if ble.state == .connected {
                Text("RSSI: \(ble.currentRSSI) dBm")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
    }
    
    private var statusColor: Color {
        switch ble.state {
        case .connected: return .green
        case .connecting, .scanning: return .orange
        case .poweredOff, .unauthorized: return .red
        default: return .gray
        }
    }
    
    // MARK: - Vista de escaneo
    private var scanView: some View {
        VStack {
            List(ble.devices) { device in
                Button {
                    ble.connect(device)
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(device.name).font(.headline)
                            Text(device.id.uuidString.prefix(8) + "...")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("\(device.rssi) dBm")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .foregroundStyle(.primary)
            }
            
            Button {
                ble.state == .scanning ? ble.stopScan() : ble.startScan()
            } label: {
                Label(
                    ble.state == .scanning ? "Detener" : "Escanear",
                    systemImage: ble.state == .scanning ? "stop.circle" : "magnifyingglass"
                )
                .frame(maxWidth: .infinity)
                .padding()
                .background(.tint)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
            .disabled(ble.state == .poweredOff || ble.state == .unauthorized)
        }
    }
    
    // MARK: - Consola de comandos
    private var consoleView: some View {
        VStack(spacing: 12) {
            // Botones de comandos
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                commandButton("PING", color: .blue)
                commandButton("STATUS", color: .purple)
                commandButton("LED_ON", color: .green)
                commandButton("LED_OFF", color: .gray)
            }
            .padding(.horizontal)
            
            // Log
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 4) {
                        ForEach(Array(ble.receivedMessages.enumerated()), id: \.offset) { idx, msg in
                            Text(msg)
                                .font(.system(.caption, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .id(idx)
                        }
                    }
                    .padding()
                }
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .onChange(of: ble.receivedMessages.count) { _, newCount in
                    withAnimation {
                        proxy.scrollTo(newCount - 1, anchor: .bottom)
                    }
                }
            }
            
            Button(role: .destructive) {
                ble.disconnect()
            } label: {
                Label("Desconectar", systemImage: "xmark.circle")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .foregroundStyle(.red)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
    
    private func commandButton(_ cmd: String, color: Color) -> some View {
        Button {
            ble.send(cmd)
        } label: {
            Text(cmd)
                .font(.system(.body, design: .monospaced).weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(color)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    ContentView().environmentObject(BLEManager())
}
