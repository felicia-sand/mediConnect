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
    @AppStorage("selectedTheme") private var selectedTheme: String = "System (Light)"
    
    init() {
        #if canImport(FirebaseCore)
        // Automatically configure Firebase if GoogleService-Info.plist is provided
        if Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil {
            FirebaseApp.configure()
        }
        #endif
        
        // Request notification authorization on app launch (Coursework Requirement)
        NotificationService.shared.requestAuthorization()
    }
    
    private var activeColorScheme: ColorScheme? {
        switch selectedTheme {
        case "Dark Mode":
            return .dark
        case "Light Mode":
            return .light
        default:
            return nil // Follow System
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .preferredColorScheme(activeColorScheme)
        }
    }
}
