// FirebaseAuthService.swift
// MediConnect — Core/Database
//
// Firebase Authentication Service (PRD Backend Architecture):
// - Direct bridge for Firebase Auth (Email/Password & Account creation)
// - Synchronizes authenticated auth credentials with Cloud Firestore user profiles
// - Graceful fallback to mock authentication when offline or GoogleService-Info.plist is pending

import Foundation

#if canImport(FirebaseAuth)
import FirebaseAuth
#endif

@MainActor
final class FirebaseAuthService: ObservableObject {
    
    static let shared = FirebaseAuthService()
    
    @Published var isCloudAuthEnabled: Bool = false
    @Published var currentFirebaseUserEmail: String?
    
    private init() {
        checkCloudAuthAvailability()
    }
    
    private func checkCloudAuthAvailability() {
        #if canImport(FirebaseAuth)
        if Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil {
            self.isCloudAuthEnabled = true
            self.currentFirebaseUserEmail = Auth.auth().currentUser?.email
        } else {
            self.isCloudAuthEnabled = false
        }
        #else
        self.isCloudAuthEnabled = false
        #endif
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) async throws -> User {
        #if canImport(FirebaseAuth)
        if isCloudAuthEnabled {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            let uid = authResult.user.uid
            
            // Fetch profile document from Firestore
            return try await FirestoreService.shared.fetchUser(by: uid)
        }
        #endif
        
        // Local deterministic patient profile
        return User.mockPatient
    }
    
    // MARK: - Sign Up
    func signUp(fullName: String, email: String, password: String, role: UserRole) async throws -> User {
        #if canImport(FirebaseAuth)
        if isCloudAuthEnabled {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = authResult.user.uid
            
            let newUser = User(
                id: uid,
                fullName: fullName,
                email: email,
                phoneNumber: nil,
                role: role,
                createdAt: Date()
            )
            
            // Commit user profile to Firestore database
            try await FirestoreService.shared.saveUser(newUser)
            return newUser
        }
        #endif
        
        // Local newly-created user
        let newUser = User(
            id: "user-" + UUID().uuidString.prefix(8).lowercased(),
            fullName: fullName,
            email: email,
            phoneNumber: nil,
            role: role,
            createdAt: Date()
        )
        try await FirestoreService.shared.saveUser(newUser)
        return newUser
    }
    
    // MARK: - Password Reset
    func sendPasswordReset(email: String) async throws {
        #if canImport(FirebaseAuth)
        if isCloudAuthEnabled {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            return
        }
        #endif
    }
    
    // MARK: - Sign Out
    func signOut() throws {
        #if canImport(FirebaseAuth)
        if isCloudAuthEnabled {
            try Auth.auth().signOut()
        }
        #endif
        currentFirebaseUserEmail = nil
    }
}
