// AppConstants.swift
// MediConnect — Core/Utilities
//
// Created by Felicia on 25/10/2026.

import Foundation

// MARK: - App Constants
enum AppConstants {
    
    // MARK: - App Info
    enum App {
        static let name        = "MediConnect"
        static let version     = "1.0.0"
        static let bundleId    = "com.felicia.mediConnect"
        static let supportEmail = "support@mediconnect.app"
    }
    
    // MARK: - API
    enum API {
        static let baseURL     = "https://api.mediconnect.app/v1"
        static let timeout: TimeInterval = 30.0
    }
    
    // MARK: - Firebase
    enum Firebase {
        static let usersCollection       = "users"
        static let doctorsCollection     = "doctors"
        static let appointmentsCollection = "appointments"
        static let conversationsCollection = "conversations"
        static let messagesCollection    = "messages"
    }
    
    // MARK: - UserDefaults Keys
    enum UserDefaultsKeys {
        static let isOnboardingComplete  = "isOnboardingComplete"
        static let lastSyncDate          = "lastSyncDate"
        static let preferredLanguage     = "preferredLanguage"
        static let notificationsEnabled  = "notificationsEnabled"
    }
    
    // MARK: - UI
    enum UI {
        static let cornerRadius: CGFloat     = 12
        static let largeCornerRadius: CGFloat = 20
        static let animationDuration: Double  = 0.3
        static let shadowRadius: CGFloat      = 8
    }
    
    // MARK: - Validation
    enum Validation {
        static let minPasswordLength: Int = 6
        static let maxPasswordLength: Int = 128
        static let maxBioLength: Int      = 500
    }
}
