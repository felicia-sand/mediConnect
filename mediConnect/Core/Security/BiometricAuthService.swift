// BiometricAuthService.swift
// MediConnect — Core/Security
//
// Biometric Authentication Service utilizing LocalAuthentication (Face ID / Touch ID)
// Designed for fast, secure patient authentication according to MediConnect PRD.

import Foundation
import LocalAuthentication

// MARK: - Biometric Error
public enum BiometricAuthError: LocalizedError {
    case notAvailable
    case notEnrolled
    case failed(String)
    case cancelled
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "Biometric authentication is not supported or not available on this device."
        case .notEnrolled:
            return "No Face ID or biometric identity has been enrolled in device settings."
        case .failed(let reason):
            return "Biometric authentication failed: \(reason)"
        case .cancelled:
            return "Authentication was cancelled by the user."
        case .unknown:
            return "An unknown biometric error occurred."
        }
    }
}

// MARK: - Biometric Type
public enum BiometricType {
    case none
    case touchID
    case faceID
    case opticID
    
    public var displayName: String {
        switch self {
        case .none:     return "Passcode"
        case .touchID:  return "Touch ID"
        case .faceID:   return "Face ID"
        case .opticID:  return "Optic ID"
        }
    }
}

// MARK: - BiometricAuthService
@MainActor
public final class BiometricAuthService: ObservableObject {
    
    public static let shared = BiometricAuthService()
    
    public init() {}
    
    /// Detect supported biometric type on the current device
    public var biometricType: BiometricType {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        
        switch context.biometryType {
        case .faceID:   return .faceID
        case .touchID:  return .touchID
        case .opticID:  return .opticID
        case .none:     return .none
        @unknown default: return .none
        }
    }
    
    /// Check if biometrics can currently be evaluated
    public var canAuthenticate: Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    /// Authenticate the patient using Face ID / Touch ID
    public func authenticate(reason: String = "Sign in to MediConnect to access your health appointments.") async throws -> Bool {
        let context = LAContext()
        context.localizedCancelTitle = "Cancel"
        
        var authError: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) else {
            if let error = authError {
                if error.code == LAError.biometryNotEnrolled.rawValue {
                    throw BiometricAuthError.notEnrolled
                } else {
                    throw BiometricAuthError.notAvailable
                }
            }
            throw BiometricAuthError.notAvailable
        }
        
        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            )
            return success
        } catch let error as LAError {
            switch error.code {
            case .userCancel, .appCancel, .systemCancel:
                throw BiometricAuthError.cancelled
            case .biometryNotEnrolled:
                throw BiometricAuthError.notEnrolled
            default:
                throw BiometricAuthError.failed(error.localizedDescription)
            }
        } catch {
            throw BiometricAuthError.unknown
        }
    }
}
