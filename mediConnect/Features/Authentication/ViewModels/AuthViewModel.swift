// AuthViewModel.swift
// MediConnect — Features/Authentication/ViewModels
//
// Complete Authentication State Machine and Business Logic
// Conforms to Figma screens, UI navigation matrix, and PRD specifications.

import Foundation
import Combine
import SwiftUI

// MARK: - Authentication Flow State
enum AuthFlowState: Equatable {
    case splash
    case login
    case signUp
    case verifySignUpOTP
    case forgotPassword
    case verifyResetOTP
    case createNewPassword
    case authenticated
}

// MARK: - AuthViewModel
@MainActor
final class AuthViewModel: ObservableObject {
    
    // MARK: - Navigation & Flow State
    @Published var flowState: AuthFlowState = .splash
    @Published var currentUser: User?
    @Published var isLoading: Bool = false
    @Published var isBiometricLoading: Bool = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    // MARK: - Login Form Fields
    @Published var email: String = ""
    @Published var password: String = ""
    
    // MARK: - Registration Form Fields
    @Published var fullName: String = ""
    @Published var emailOrPhone: String = ""
    @Published var confirmPassword: String = ""
    @Published var selectedRole: UserRole = .patient
    
    // MARK: - Verification (OTP) Fields
    @Published var otpCode: String = ""
    @Published var maskedContact: String = "fe******@gmail.com"
    @Published var resendCountdown: Int = 30
    @Published var canResendCode: Bool = false
    
    // MARK: - Password Reset Fields
    @Published var forgotPasswordInput: String = ""
    @Published var newPassword: String = ""
    @Published var confirmNewPassword: String = ""
    
    // MARK: - Private State
    private var timerCancellable: AnyCancellable?
    
    // MARK: - Computed Properties
    var isAuthenticated: Bool {
        flowState == .authenticated && currentUser != nil
    }
    
    var isLoginFormValid: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        password.count >= 6
    }
    
    var isSignUpFormValid: Bool {
        !fullName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !emailOrPhone.trimmingCharacters(in: .whitespaces).isEmpty &&
        password.count >= 8 &&
        password == confirmPassword
    }
    
    var isNewPasswordValid: Bool {
        newPassword.count >= 8 &&
        newPassword == confirmNewPassword &&
        newPassword.rangeOfCharacter(from: .uppercaseLetters) != nil &&
        newPassword.rangeOfCharacter(from: .decimalDigits) != nil
    }
    
    var formattedCountdown: String {
        String(format: "00:%02d", resendCountdown)
    }
    
    // MARK: - Init
    init() {
        checkSession()
    }
    
    // MARK: - Flow Navigation Methods
    func navigateTo(_ state: AuthFlowState) {
        errorMessage = nil
        successMessage = nil
        otpCode = ""
        flowState = state
        
        if state == .verifySignUpOTP || state == .verifyResetOTP {
            startResendTimer()
        } else {
            stopResendTimer()
        }
    }
    
    // MARK: - Session Lifecycle
    func checkSession() {
        isLoading = true
        flowState = .splash
        
        Task {
            // Simulated session check delay (1 second splash screen)
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            // In initial launch, route to login screen
            self.isLoading = false
            self.flowState = .login
        }
    }
    
    // MARK: - Sign In
    func signIn() async {
        guard isLoginFormValid else {
            errorMessage = "Please enter a valid email and password."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // Simulated network authentication delay (Firebase Auth integration point)
            try await Task.sleep(nanoseconds: 900_000_000)
            
            let user = User.mockPatient
            self.currentUser = user
            self.flowState = .authenticated
        } catch {
            errorMessage = "Invalid credentials. Please verify your email and password."
        }
        
        isLoading = false
    }
    
    // MARK: - Biometric (Face ID) Authentication
    func signInWithFaceID() async {
        isBiometricLoading = true
        errorMessage = nil
        
        do {
            let success = try await BiometricAuthService.shared.authenticate(
                reason: "Sign in to MediConnect to manage your healthcare appointments."
            )
            
            if success {
                let user = User.mockPatient
                self.currentUser = user
                self.flowState = .authenticated
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isBiometricLoading = false
    }
    
    // MARK: - Registration Flow
    func createAccount() async {
        guard isSignUpFormValid else {
            if password != confirmPassword {
                errorMessage = "Passwords do not match."
            } else if password.count < 8 {
                errorMessage = "Password must be at least 8 characters long."
            } else {
                errorMessage = "Please fill in all required fields."
            }
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await Task.sleep(nanoseconds: 800_000_000)
            
            // Mask contact for display in verification screen
            maskedContact = maskContact(emailOrPhone)
            navigateTo(.verifySignUpOTP)
        } catch {
            errorMessage = "Failed to create account. Please try again."
        }
        
        isLoading = false
    }
    
    // MARK: - Verify Account OTP
    func verifySignUpOTP() async {
        guard otpCode.count == 6 else {
            errorMessage = "Please enter all 6 digits of the confirmation code."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await Task.sleep(nanoseconds: 800_000_000)
            
            // Create user entity upon successful verification
            let newUser = User(
                id: "user-" + UUID().uuidString.prefix(8).lowercased(),
                fullName: fullName,
                email: emailOrPhone.contains("@") ? emailOrPhone : "patient@mediconnect.app",
                phoneNumber: emailOrPhone.contains("@") ? nil : emailOrPhone,
                role: selectedRole,
                createdAt: Date()
            )
            self.currentUser = newUser
            self.flowState = .authenticated
        } catch {
            errorMessage = "Invalid verification code. Please check and try again."
        }
        
        isLoading = false
    }
    
    // MARK: - Forgot Password Flow
    func sendForgotPasswordCode() async {
        let input = forgotPasswordInput.trimmingCharacters(in: .whitespaces)
        guard !input.isEmpty else {
            errorMessage = "Please enter your registered email or phone number."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await Task.sleep(nanoseconds: 800_000_000)
            maskedContact = maskContact(input)
            navigateTo(.verifyResetOTP)
        } catch {
            errorMessage = "Could not send reset code. Please try again."
        }
        
        isLoading = false
    }
    
    // MARK: - Verify Reset Code OTP
    func verifyResetOTP() async {
        guard otpCode.count == 6 else {
            errorMessage = "Please enter all 6 digits of the verification code."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await Task.sleep(nanoseconds: 800_000_000)
            navigateTo(.createNewPassword)
        } catch {
            errorMessage = "Invalid verification code. Try again."
        }
        
        isLoading = false
    }
    
    // MARK: - Reset Password
    func resetNewPassword() async {
        guard isNewPasswordValid else {
            if newPassword != confirmNewPassword {
                errorMessage = "Passwords do not match."
            } else {
                errorMessage = "Password does not satisfy all security criteria."
            }
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await Task.sleep(nanoseconds: 900_000_000)
            successMessage = "Your password has been reset successfully. Please sign in."
            navigateTo(.login)
        } catch {
            errorMessage = "Failed to update password. Please try again."
        }
        
        isLoading = false
    }
    
    // MARK: - OTP Timer & Resend
    func startResendTimer() {
        resendCountdown = 30
        canResendCode = false
        timerCancellable?.cancel()
        
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.resendCountdown > 1 {
                    self.resendCountdown -= 1
                } else {
                    self.resendCountdown = 0
                    self.canResendCode = true
                    self.timerCancellable?.cancel()
                }
            }
    }
    
    func stopResendTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    func resendOTP() async {
        guard canResendCode else { return }
        errorMessage = nil
        
        do {
            try await Task.sleep(nanoseconds: 600_000_000)
            startResendTimer()
        } catch {
            errorMessage = "Could not resend code. Please try again later."
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        currentUser = nil
        flowState = .login
        email = ""
        password = ""
        fullName = ""
        emailOrPhone = ""
        confirmPassword = ""
        otpCode = ""
        forgotPasswordInput = ""
        newPassword = ""
        confirmNewPassword = ""
        errorMessage = nil
        successMessage = nil
    }
    
    // MARK: - Helper Formatting
    private func maskContact(_ contact: String) -> String {
        let trimmed = contact.trimmingCharacters(in: .whitespaces)
        if trimmed.contains("@") {
            let parts = trimmed.components(separatedBy: "@")
            guard let name = parts.first, let domain = parts.last else { return trimmed }
            let prefix = String(name.prefix(2))
            return "\(prefix)******@\(domain)"
        } else {
            // Mask phone number
            if trimmed.count > 4 {
                let suffix = String(trimmed.suffix(3))
                return "+94 77******\(suffix)"
            }
            return trimmed
        }
    }
}
