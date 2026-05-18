//
//  DesktopRoverApp.swift
//  DesktopRover
//
//  Created by Francisco David Zárate Vásquez on 17/05/26.
//

import SwiftUI

@main
struct DesktopRoverApp: App {
    @StateObject private var ble = BLEManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ble)
        }
    }
}
