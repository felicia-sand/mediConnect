// AuthenticationView.swift
// MediConnect — Features/Authentication/Views
//
// Created by Felicia on 25/10/2026.

import SwiftUI

struct AuthenticationView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSignUp: Bool = false
    
    var body: some View {
        NavigationStack {
            if showSignUp {
                SignUpView(showSignUp: $showSignUp)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)
                    ))
            } else {
                LoginView(showSignUp: $showSignUp)
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading),
                        removal: .move(edge: .trailing)
                    ))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showSignUp)
    }
}

// MARK: - Login View
struct LoginView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var showSignUp: Bool
    @State private var showPassword: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                
                // MARK: Header
                VStack(spacing: 12) {
                    Image(systemName: "cross.case.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(colors: [.blue, .cyan],
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                        )
                    
                    Text("MediConnect")
                        .font(.largeTitle.bold())
                    
                    Text("Your health, connected.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 60)
                
                // MARK: Form
                VStack(spacing: 16) {
                    MCTextField(
                        icon: "envelope.fill",
                        placeholder: "Email address",
                        text: $authViewModel.email,
                        keyboardType: .emailAddress
                    )
                    
                    MCTextField(
                        icon: "lock.fill",
                        placeholder: "Password",
                        text: $authViewModel.password,
                        isSecure: !showPassword,
                        trailingButton: {
                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    )
                    
                    // Forgot Password
                    HStack {
                        Spacer()
                        Button("Forgot password?") {
                            // TODO: Navigate to reset password
                        }
                        .font(.footnote)
                        .foregroundStyle(.blue)
                    }
                }
                
                // MARK: Error
                if let error = authViewModel.errorMessage {
                    Label(error, systemImage: "exclamationmark.triangle.fill")
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }
                
                // MARK: Sign In Button
                MCPrimaryButton(
                    title: "Sign In",
                    isLoading: authViewModel.isLoading,
                    isDisabled: !authViewModel.isLoginFormValid
                ) {
                    Task { await authViewModel.signIn() }
                }
                
                // MARK: Divider
                HStack {
                    Rectangle().frame(height: 1).foregroundStyle(.quaternary)
                    Text("or").font(.footnote).foregroundStyle(.secondary)
                    Rectangle().frame(height: 1).foregroundStyle(.quaternary)
                }
                
                // MARK: Sign Up CTA
                Button {
                    showSignUp = true
                } label: {
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundStyle(.secondary)
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue)
                    }
                    .font(.subheadline)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Sign Up View
struct SignUpView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var showSignUp: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Header
                VStack(spacing: 8) {
                    Text("Create Account")
                        .font(.largeTitle.bold())
                    Text("Join MediConnect today")
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 60)
                
                // Role Picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("I am a...")
                        .font(.subheadline).fontWeight(.medium)
                    
                    Picker("Role", selection: $authViewModel.selectedRole) {
                        Text("Patient").tag(UserRole.patient)
                        Text("Doctor").tag(UserRole.doctor)
                    }
                    .pickerStyle(.segmented)
                }
                
                // Form Fields
                VStack(spacing: 16) {
                    MCTextField(icon: "person.fill", placeholder: "Full name",
                                text: $authViewModel.fullName)
                    MCTextField(icon: "envelope.fill", placeholder: "Email address",
                                text: $authViewModel.email, keyboardType: .emailAddress)
                    MCTextField(icon: "lock.fill", placeholder: "Password",
                                text: $authViewModel.password, isSecure: true)
                    MCTextField(icon: "lock.shield.fill", placeholder: "Confirm password",
                                text: $authViewModel.confirmPassword, isSecure: true)
                }
                
                if let error = authViewModel.errorMessage {
                    Label(error, systemImage: "exclamationmark.triangle.fill")
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
                
                MCPrimaryButton(
                    title: "Create Account",
                    isLoading: authViewModel.isLoading,
                    isDisabled: !authViewModel.isSignUpFormValid
                ) {
                    Task { await authViewModel.signUp() }
                }
                
                Button {
                    showSignUp = false
                } label: {
                    HStack(spacing: 4) {
                        Text("Already have an account?").foregroundStyle(.secondary)
                        Text("Sign In").fontWeight(.semibold).foregroundStyle(.blue)
                    }
                    .font(.subheadline)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Reusable Components

struct MCTextField<TrailingContent: View>: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    @ViewBuilder var trailingButton: () -> TrailingContent
    
    init(icon: String, placeholder: String, text: Binding<String>,
         keyboardType: UIKeyboardType = .default, isSecure: Bool = false,
         @ViewBuilder trailingButton: @escaping () -> TrailingContent = { EmptyView() }) {
        self.icon = icon
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.isSecure = isSecure
        self.trailingButton = trailingButton
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 20)
            
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
            }
            
            trailingButton()
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
        )
    }
}

struct MCPrimaryButton: View {
    let title: String
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text(title).fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .foregroundStyle(.white)
            .background(
                LinearGradient(colors: [.blue, .cyan],
                               startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .opacity(isDisabled ? 0.6 : 1)
        }
        .disabled(isDisabled || isLoading)
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthViewModel())
}
