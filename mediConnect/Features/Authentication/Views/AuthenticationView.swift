// AuthenticationView.swift
// MediConnect — Features/Authentication/Views
//
// Root Authentication Navigation Router
// Manages smooth transitions between Splash, Login, Registration, OTP, and Password Recovery

import SwiftUI

struct AuthenticationView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                switch authViewModel.flowState {
                case .splash:
                    SplashView()
                        .transition(.opacity)
                    
                case .login:
                    LoginView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                    
                case .signUp:
                    SignUpView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                    
                case .verifySignUpOTP:
                    OTPVerificationView(mode: .signUp)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                    
                case .forgotPassword:
                    ForgotPasswordView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                    
                case .verifyResetOTP:
                    OTPVerificationView(mode: .passwordReset)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                    
                case .createNewPassword:
                    CreateNewPasswordView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                    
                case .authenticated:
                    EmptyView()
                }
            }
            .animation(.easeInOut(duration: 0.3), value: authViewModel.flowState)
        }
    }
}

#if DEBUG
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(AuthViewModel())
    }
}
#endif
