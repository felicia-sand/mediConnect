// AuthViewModel.swift
// MediConnect — Features/Authentication/ViewModels
//
// Created by Felicia on 25/10/2026.

import Foundation
import Combine

// MARK: - Auth State
enum AuthState {
    case idle
    case loading
    case authenticated(User)
    case unauthenticated
    case error(String)
}

// MARK: - AuthViewModel
@MainActor
final class AuthViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var authState: AuthState = .unauthenticated
    @Published var currentUser: User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Form Fields
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var fullName: String = ""
    @Published var confirmPassword: String = ""
    @Published var selectedRole: UserRole = .patient
    
    // MARK: - Computed
    var isAuthenticated: Bool {
        if case .authenticated = authState { return true }
        return false
    }
    
    var isLoginFormValid: Bool {
        !email.isEmpty && !password.isEmpty && password.count >= 6
    }
    
    var isSignUpFormValid: Bool {
        !fullName.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword &&
        password.count >= 6
    }
    
    // MARK: - Private
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        checkAuthStatus()
    }
    
    // MARK: - Methods
    
    /// Check if user is already logged in
    func checkAuthStatus() {
        // TODO: Integrate with Firebase Auth
        // For now, default to unauthenticated
        authState = .unauthenticated
    }
    
    /// Sign in with email and password
    func signIn() async {
        guard isLoginFormValid else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            // TODO: Replace with Firebase Auth call
            try await Task.sleep(nanoseconds: 1_000_000_000) // Simulated delay
            
            // Mock successful login
            let user = User.mockPatient
            currentUser = user
            authState = .authenticated(user)
        } catch {
            errorMessage = "Sign in failed. Please check your credentials."
            authState = .error(error.localizedDescription)
        }
        
        isLoading = false
    }
    
    /// Create a new account
    func signUp() async {
        guard isSignUpFormValid else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            // TODO: Replace with Firebase Auth call
            try await Task.sleep(nanoseconds: 1_200_000_000) // Simulated delay
            
            // Mock successful sign up
            let newUser = User(
                id: UUID().uuidString,
                fullName: fullName,
                email: email,
                role: selectedRole,
                createdAt: Date()
            )
            currentUser = newUser
            authState = .authenticated(newUser)
        } catch {
            errorMessage = "Sign up failed. Please try again."
            authState = .error(error.localizedDescription)
        }
        
        isLoading = false
    }
    
    /// Sign out the current user
    func signOut() {
        // TODO: Firebase Auth signOut
        currentUser = nil
        authState = .unauthenticated
        clearForm()
    }
    
    /// Reset password via email
    func resetPassword() async {
        guard !email.isEmpty else { return }
        isLoading = true
        
        do {
            // TODO: Firebase password reset
            try await Task.sleep(nanoseconds: 800_000_000)
            // Show success message
        } catch {
            errorMessage = "Password reset failed. Try again."
        }
        
        isLoading = false
    }
    
    // MARK: - Helpers
    private func clearForm() {
        email = ""
        password = ""
        fullName = ""
        confirmPassword = ""
    }
}
