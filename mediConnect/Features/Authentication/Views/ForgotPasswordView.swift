// ForgotPasswordView.swift
// MediConnect — Features/Authentication/Views
//
// Password Recovery View matching Figma specifications:
// - Key icon header badge
// - Registered email or phone input
// - "Send Verification Code →" action
// - Navigation back to Sign In

import SwiftUI

struct ForgotPasswordView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    init() {}
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 28) {
                
                // Back Button Bar
                HStack {
                    Button {
                        authViewModel.navigateTo(.login)
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 15, weight: .semibold))
                            Text("Sign In")
                                .font(.system(size: 15, weight: .medium))
                        }
                        .foregroundStyle(Color.mcTeal)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
                .padding(.top, 16)
                
                // Top Key Badge
                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.mcTealLight)
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "key.fill")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundStyle(Color.mcTeal)
                    }
                    
                    VStack(spacing: 6) {
                        Text("Forgot your password?")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(Color.mcTextPrimary)
                        
                        Text("Enter the email or phone number associated with\nyour account and we'll send you a verification code.")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.mcTextSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                    }
                }
                .padding(.top, 16)
                
                // Input Form
                MCInputField(
                    label: "Email or Phone",
                    placeholder: "Enter your email or phone number",
                    text: $authViewModel.forgotPasswordInput,
                    helperText: "We'll send a 6-digit verification code to reset your password."
                )
                
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
                    title: "Send Verification Code →",
                    isLoading: authViewModel.isLoading,
                    isDisabled: authViewModel.forgotPasswordInput.trimmingCharacters(in: .whitespaces).isEmpty
                ) {
                    Task { await authViewModel.sendForgotPasswordCode() }
                }
                .padding(.top, 8)
                
                // Footer
                Button {
                    authViewModel.navigateTo(.login)
                } label: {
                    HStack(spacing: 4) {
                        Text("Remember your password?")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.mcTextSecondary)
                        
                        Text("Back to Sign In")
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
struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
            .environmentObject(AuthViewModel())
    }
}
#endif
