// SignUpView.swift
// MediConnect — Features/Authentication/Views
//
// Patient Registration View matching Figma specifications:
// - User-plus header badge
// - Full Name, Email or Phone, Password, Confirm Password fields
// - "Create Account →" button
// - Navigation to OTP verification screen and Sign In

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    init() {}
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                
                // Top Badge
                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.mcTealLight)
                            .frame(width: 56, height: 56)
                        
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(Color.mcTeal)
                    }
                    .padding(.top, 32)
                    
                    VStack(spacing: 6) {
                        Text("Create your account")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(Color.mcTextPrimary)
                        
                        Text("Sign up to find doctors and manage your\nappointments.")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.mcTextSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                    }
                }
                
                // Form Inputs
                VStack(spacing: 16) {
                    MCInputField(
                        label: "Full Name",
                        placeholder: "Enter your full name",
                        text: $authViewModel.fullName
                    )
                    
                    MCInputField(
                        label: "Email or Phone",
                        placeholder: "Enter your email or phone number",
                        text: $authViewModel.emailOrPhone,
                        helperText: "We'll send an confirmation code"
                    )
                    
                    MCInputField(
                        label: "Password",
                        placeholder: "Create a password",
                        text: $authViewModel.password,
                        isSecure: true
                    )
                    
                    MCInputField(
                        label: "Confirm Password",
                        placeholder: "Re-enter your password",
                        text: $authViewModel.confirmPassword,
                        isSecure: true
                    )
                }
                
                // Error Message
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
                
                // Action Button
                MCPrimaryButton(
                    title: "Create Account →",
                    isLoading: authViewModel.isLoading,
                    isDisabled: !authViewModel.isSignUpFormValid
                ) {
                    Task { await authViewModel.createAccount() }
                }
                .padding(.top, 8)
                
                // Footer
                Button {
                    authViewModel.navigateTo(.login)
                } label: {
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.mcTextSecondary)
                        
                        Text("Sign In")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.mcTeal)
                    }
                }
                .buttonStyle(.plain)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 24)
        }
        .background(Color.white.ignoresSafeArea())
    }
}

#if DEBUG
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(AuthViewModel())
    }
}
#endif
