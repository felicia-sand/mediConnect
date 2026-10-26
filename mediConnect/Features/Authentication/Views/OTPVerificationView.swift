// OTPVerificationView.swift
// MediConnect — Features/Authentication/Views
//
// 6-digit OTP Verification View matching Figma specifications:
// - Supports both Account Verification (Sign Up) and Identity Verification (Forgot Password)
// - Masked contact destination pill
// - 6-digit auto-advancing code boxes
// - Live countdown timer with active "Resend Code" trigger

import SwiftUI

struct OTPVerificationView: View {
    
    // MARK: - Mode
    enum Mode {
        case signUp
        case passwordReset
        
        var title: String {
            switch self {
            case .signUp:        return "Verify your account"
            case .passwordReset: return "Verify your identity"
            }
        }
        
        var buttonTitle: String {
            switch self {
            case .signUp:        return "Verify Account →"
            case .passwordReset: return "Verify Code →"
            }
        }
    }
    
    // MARK: - Properties
    let mode: Mode
    @EnvironmentObject var authViewModel: AuthViewModel
    
    init(mode: Mode = .signUp) {
        self.mode = mode
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 28) {
                
                // Back Button Bar
                HStack {
                    Button {
                        if mode == .signUp {
                            authViewModel.navigateTo(.signUp)
                        } else {
                            authViewModel.navigateTo(.forgotPassword)
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 15, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 15, weight: .medium))
                        }
                        .foregroundStyle(Color.mcTeal)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
                .padding(.top, 16)
                
                // Top Shield Badge
                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.mcTealLight)
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(Color.mcTeal)
                    }
                    
                    VStack(spacing: 6) {
                        Text(mode.title)
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(Color.mcTextPrimary)
                        
                        Text("We sent a 6-digit confirmation code to\nyour registered contact.")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.mcTextSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                    }
                    
                    // Masked Destination Pill
                    HStack(spacing: 6) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.mcTeal)
                        
                        Text(authViewModel.maskedContact)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.mcTextPrimary)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(Color.mcTealLight.opacity(0.6))
                    .clipShape(Capsule())
                }
                .padding(.top, 12)
                
                // 6-digit OTP Box
                VStack(spacing: 12) {
                    MCOTPCodeField(codeLength: 6, code: $authViewModel.otpCode)
                    
                    if mode == .passwordReset {
                        Text("Enter all 6 numerical digits to continue")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.mcTextSecondary)
                    }
                }
                .padding(.top, 8)
                
                // Resend Countdown Row
                HStack(spacing: 4) {
                    Text("Didn't receive the code?")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.mcTextSecondary)
                    
                    if authViewModel.canResendCode {
                        Button {
                            Task { await authViewModel.resendOTP() }
                        } label: {
                            Text("Resend Code")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(Color.mcTeal)
                        }
                        .buttonStyle(.plain)
                    } else {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 11))
                            Text("Resend available in \(authViewModel.formattedCountdown)")
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundStyle(Color.mcTextSecondary)
                    }
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
                    title: mode.buttonTitle,
                    isLoading: authViewModel.isLoading,
                    isDisabled: authViewModel.otpCode.count < 6
                ) {
                    Task {
                        if mode == .signUp {
                            await authViewModel.verifySignUpOTP()
                        } else {
                            await authViewModel.verifyResetOTP()
                        }
                    }
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .background(Color.white.ignoresSafeArea())
    }
}

#if DEBUG
struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerificationView(mode: .signUp)
            .environmentObject(AuthViewModel())
    }
}
#endif
