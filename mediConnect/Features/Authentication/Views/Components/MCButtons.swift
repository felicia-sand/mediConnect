// MCButtons.swift
// MediConnect — Features/Authentication/Views/Components
//
// Reusable button components matching Figma design specifications:
// - MCPrimaryButton: Deep teal full-width CTA with arrow and loading spinner
// - MCBiometricButton: Outlined Face ID authentication button

import SwiftUI

// MARK: - Primary Action Button
public struct MCPrimaryButton: View {
    
    public let title: String
    public var isLoading: Bool = false
    public var isDisabled: Bool = false
    public let action: () -> Void
    
    public init(
        title: String,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.mcTeal)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .opacity(isDisabled ? 0.5 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isDisabled)
            .animation(.easeInOut(duration: 0.2), value: isLoading)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled || isLoading)
    }
}

// MARK: - Biometric (Face ID) Button
public struct MCBiometricButton: View {
    
    public let title: String
    public var isLoading: Bool = false
    public let action: () -> Void
    
    public init(
        title: String = "Sign in with Face ID",
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isLoading = isLoading
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(Color.mcTeal)
                } else {
                    Image(systemName: "faceid")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color.mcTeal)
                    
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.mcTeal)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.mcTealLight.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.mcTealBorder, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
    }
}

#if DEBUG
struct MCButtons_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            MCPrimaryButton(title: "Sign In →") {}
            MCPrimaryButton(title: "Signing In...", isLoading: true) {}
            MCPrimaryButton(title: "Create Account →", isDisabled: true) {}
            MCBiometricButton {}
        }
        .padding()
    }
}
#endif
