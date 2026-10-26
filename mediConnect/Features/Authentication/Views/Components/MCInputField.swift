// MCInputField.swift
// MediConnect — Features/Authentication/Views/Components
//
// Reusable text input field matching Figma design specifications:
// - Uppercase field label
// - Clean rounded input box with subtle border
// - Secure toggle button with eye icon
// - Helper and error text support

import SwiftUI

public struct MCInputField: View {
    
    // MARK: - Properties
    public let label: String
    public let placeholder: String
    @Binding public var text: String
    public var isSecure: Bool = false
    public var keyboardType: UIKeyboardType = .default
    public var helperText: String? = nil
    public var errorMessage: String? = nil
    
    // MARK: - State
    @State private var isPasswordVisible: Bool = false
    @FocusState private var isFocused: Bool
    
    // MARK: - Init
    public init(
        label: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        helperText: String? = nil,
        errorMessage: String? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.helperText = helperText
        self.errorMessage = errorMessage
    }
    
    // MARK: - Body
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            // Uppercase Field Label
            if !label.isEmpty {
                Text(label.uppercased())
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.mcTextLabel)
                    .tracking(0.5)
            }
            
            // Input Box
            HStack(spacing: 12) {
                if isSecure && !isPasswordVisible {
                    SecureField(placeholder, text: $text)
                        .font(.system(size: 15))
                        .foregroundStyle(Color.mcTextPrimary)
                        .focused($isFocused)
                        .autocorrectionDisabled()
                        #if os(iOS)
                        .textInputAutocapitalization(.never)
                        #endif
                } else {
                    TextField(placeholder, text: $text)
                        .font(.system(size: 15))
                        .foregroundStyle(Color.mcTextPrimary)
                        .focused($isFocused)
                        .autocorrectionDisabled()
                        #if os(iOS)
                        .keyboardType(keyboardType)
                        .textInputAutocapitalization(.never)
                        #endif
                }
                
                // Password Visibility Toggle
                if isSecure {
                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .font(.system(size: 16))
                            .foregroundStyle(Color.mcTextSecondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(Color.mcInputBg)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        errorMessage != nil ? Color.mcStatusRed :
                        isFocused ? Color.mcTeal : Color.mcBorderLight,
                        lineWidth: isFocused || errorMessage != nil ? 1.5 : 1
                    )
            )
            
            // Helper Text
            if let helper = helperText, errorMessage == nil {
                HStack(spacing: 4) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 11))
                    Text(helper)
                        .font(.system(size: 12))
                }
                .foregroundStyle(Color.mcTextSecondary)
                .padding(.top, 2)
            }
            
            // Error Message
            if let error = errorMessage, !error.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 11))
                    Text(error)
                        .font(.system(size: 12))
                }
                .foregroundStyle(Color.mcStatusRed)
                .padding(.top, 2)
            }
        }
    }
}

#if canImport(UIKit)
import UIKit
#endif

#if !canImport(UIKit)
public enum UIKeyboardType {
    case `default`, emailAddress, numberPad, phonePad
}
#endif

#if DEBUG
struct MCInputField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            MCInputField(
                label: "Email",
                placeholder: "Enter your email",
                text: .constant("pasindu@example.com")
            )
            
            MCInputField(
                label: "Password",
                placeholder: "Enter your password",
                text: .constant("Secret123"),
                isSecure: true
            )
            
            MCInputField(
                label: "Email or Phone",
                placeholder: "Enter your email or phone number",
                text: .constant(""),
                helperText: "We'll send an confirmation code"
            )
        }
        .padding()
    }
}
#endif
