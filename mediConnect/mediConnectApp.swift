// mediConnectApp.swift
// MediConnect
//
// Created by Felicia on 25/10/2026.

import SwiftUI

@main
struct mediConnectApp: App {
    
    // MARK: - State
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
