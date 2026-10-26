// CreateNewPasswordView.swift
// MediConnect — Features/Authentication/Views
//
// New Password Creation View matching Figma specifications:
// - Shield & refresh header badge
// - New password & confirm password fields
// - Live criteria checks and strength meter
// - "Reset Password →" primary action

import SwiftUI

struct CreateNewPasswordView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    init() {}
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                
                // Top Shield Badge
                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.mcTealLight)
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(Color.mcTeal)
                    }
                    .padding(.top, 36)
                    
                    VStack(spacing: 6) {
                        Text("Create a new password")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(Color.mcTextPrimary)
                        
                        Text("Choose a new password for your MediConnect\naccount.")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.mcTextSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                    }
                }
                
                // Password Input Fields
                VStack(spacing: 16) {
                    MCInputField(
                        label: "New Password",
                        placeholder: "Enter your new password",
                        text: $authViewModel.newPassword,
                        isSecure: true
                    )
                    
                    MCInputField(
                        label: "Confirm Password",
                        placeholder: "Re-enter your new password",
                        text: $authViewModel.confirmNewPassword,
                        isSecure: true
                    )
                }
                
                // Live Password Rules & Strength Meter
                MCPasswordRulesView(password: authViewModel.newPassword)
                    .padding(.top, 4)
                
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
                    title: "Reset Password →",
                    isLoading: authViewModel.isLoading,
                    isDisabled: !authViewModel.isNewPasswordValid
                ) {
                    Task { await authViewModel.resetNewPassword() }
                }
                .padding(.top, 8)
                
                // Footer
                Button {
                    authViewModel.navigateTo(.login)
                } label: {
                    Text("Back to Sign In")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.mcTeal)
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
struct CreateNewPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewPasswordView()
            .environmentObject(AuthViewModel())
    }
}
#endif
