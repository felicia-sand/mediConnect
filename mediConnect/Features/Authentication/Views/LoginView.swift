// LoginView.swift
// MediConnect — Features/Authentication/Views
//
// Patient Login View matching Figma specifications:
// - Deep teal brand header badge
// - Clean email & password inputs with reveal toggle
// - "Sign In →" primary button
// - "Sign in with Face ID" biometric button
// - Navigation to "Forgot Password" and "Create Account"

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    init() {}
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 28) {
                
                // Top Brand Badge
                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.mcTeal)
                            .frame(width: 60, height: 60)
                            .shadow(color: Color.mcTeal.opacity(0.25), radius: 8, x: 0, y: 4)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .padding(.top, 40)
                    
                    VStack(spacing: 6) {
                        Text("Welcome back")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(Color.mcTextPrimary)
                        
                        Text("Sign in to manage your appointments\nand find the care you need.")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.mcTextSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                    }
                }
                
                // Form Inputs
                VStack(spacing: 16) {
                    MCInputField(
                        label: "Email",
                        placeholder: "Enter your email",
                        text: $authViewModel.email,
                        keyboardType: .emailAddress
                    )
                    
                    VStack(spacing: 8) {
                        MCInputField(
                            label: "Password",
                            placeholder: "Enter your password",
                            text: $authViewModel.password,
                            isSecure: true
                        )
                        
                        // Forgot Password Link
                        HStack {
                            Spacer()
                            Button {
                                authViewModel.navigateTo(.forgotPassword)
                            } label: {
                                Text("Forgot Password?")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(Color.mcTeal)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                // Success / Error Messages
                if let success = authViewModel.successMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.mcStatusGreen)
                        Text(success)
                            .font(.system(size: 13))
                            .foregroundStyle(Color.mcStatusGreen)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.mcStatusGreenBg)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                if let error = authViewModel.errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(Color.mcStatusRed)
                        Text(error)
                            .font(.system(size: 13))
                            .foregroundStyle(Color.mcStatusRed)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.mcStatusRed.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                // Action Buttons
                VStack(spacing: 14) {
                    MCPrimaryButton(
                        title: "Sign In →",
                        isLoading: authViewModel.isLoading,
                        isDisabled: !authViewModel.isLoginFormValid
                    ) {
                        Task { await authViewModel.signIn() }
                    }
                    
                    MCBiometricButton(
                        title: "Sign in with Face ID",
                        isLoading: authViewModel.isBiometricLoading
                    ) {
                        Task { await authViewModel.signInWithFaceID() }
                    }
                }
                .padding(.top, 8)
                
                // Footer
                Button {
                    authViewModel.navigateTo(.signUp)
                } label: {
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.mcTextSecondary)
                        
                        Text("Create Account")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.mcTeal)
                    }
                }
                .buttonStyle(.plain)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 24)
        }
        .background(Color.white.ignoresSafeArea())
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
#endif
