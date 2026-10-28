// mediConnectApp.swift
// MediConnect
//
// Created by Felicia on 25/10/2026.

import SwiftUI

#if canImport(FirebaseCore)
import FirebaseCore
#endif

@main
struct mediConnectApp: App {
    
    // MARK: - State
    @StateObject private var authViewModel = AuthViewModel()
    
    init() {
        #if canImport(FirebaseCore)
        // Automatically configure Firebase if GoogleService-Info.plist is provided
        if Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil {
            FirebaseApp.configure()
        }
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
