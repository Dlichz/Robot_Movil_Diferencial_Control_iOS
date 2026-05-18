//
//  ContentView.swift
//  DesktopRover
//
//  Created by Francisco David Zárate Vásquez on 17/05/26.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    // Escuchamos al gestor de Bluetooth. Si connectionStatus cambia allá, la vista se actualiza sola.
    @StateObject var bleManager = BluetoothManager()
    
    // Estado local para saber si nuestro botón (y el LED) debe estar prendido o apagado
    @State private var isLEDOn = false
    
    var body: some View {
        VStack(spacing: 40) {
            
            // 1. Etiqueta de Estado
            // Cambia de color (Verde/Rojo) y texto según lo que dicte el bleManager
            HStack {
                Circle()
                    .fill(bleManager.connectionStatus == "¡Conectado!" ? Color.green : Color.red)
                    .frame(width: 12, height: 12)
                Text(bleManager.connectionStatus)
                    .font(.subheadline)
            }
            .padding()
            .background(Capsule().fill(Color(.systemGroupedBackground)))
            
            Spacer()
            
            // 2. Botón de Control
            // SÓLO se muestra si el estado es "¡Conectado!"
            if bleManager.connectionStatus == "¡Conectado!" {
                Button(action: {
                    // Invierte el estado (si era true pasa a false, y viceversa)
                    isLEDOn.toggle()
                    
                    // Llama a la función del manager pasándole el nuevo estado
                    bleManager.sendLEDCommand(turnOn: isLEDOn)
                }) {
                    VStack(spacing: 15) {
                        // El icono cambia dinámicamente si está encendido o apagado
                        Image(systemName: isLEDOn ? "lightbulb.fill" : "lightbulb")
                            .font(.system(size: 80))
                            .foregroundColor(isLEDOn ? .yellow : .gray)
                        
                        Text(isLEDOn ? "APAGAR LED" : "ENCENDER LED")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200)
                            .background(isLEDOn ? Color.red : Color.blue)
                            .cornerRadius(15)
                    }
                }
            } else {
                // Si no está conectado, muestra este texto bloqueando la interacción
                Text("Espera a que el ESP32 se conecte...")
                    .foregroundColor(.secondary)
                    .italic()
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
