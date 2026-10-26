// MCPasswordRulesView.swift
// MediConnect — Features/Authentication/Views/Components
//
// Password requirements and strength indicator matching Figma "Create New password" screen:
// - Live criteria checking (8+ chars, uppercase, number)
// - Dynamic strength indicator badge (Weak / Medium / Strong)

import SwiftUI

public struct MCPasswordRulesView: View {
    
    // MARK: - Properties
    public let password: String
    
    // MARK: - Computed Criteria
    public var hasMinLength: Bool {
        password.count >= 8
    }
    
    public var hasUppercase: Bool {
        password.rangeOfCharacter(from: .uppercaseLetters) != nil
    }
    
    public var hasNumber: Bool {
        password.rangeOfCharacter(from: .decimalDigits) != nil
    }
    
    public var strength: PasswordStrength {
        let count = [hasMinLength, hasUppercase, hasNumber].filter { $0 }.count
        switch count {
        case 3:
            return .strong
        case 2:
            return .medium
        default:
            return .weak
        }
    }
    
    // MARK: - Password Strength Enum
    public enum PasswordStrength {
        case weak, medium, strong
        
        public var title: String {
            switch self {
            case .weak:   return "Weak"
            case .medium: return "Medium"
            case .strong: return "Strong"
            }
        }
        
        public var color: Color {
            switch self {
            case .weak:   return Color.mcStatusRed
            case .medium: return Color.mcStatusOrange
            case .strong: return Color.mcStatusGreen
            }
        }
    }
    
    // MARK: - Body
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // Header Row: Label & Strength Badge
            HStack {
                Text("PASSWORD MUST CONTAIN:")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.mcTextLabel)
                    .tracking(0.5)
                
                Spacer()
                
                if !password.isEmpty {
                    HStack(spacing: 4) {
                        Text("Strength:")
                            .font(.system(size: 11))
                            .foregroundStyle(Color.mcTextSecondary)
                        
                        Text(strength.title)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(strength.color)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(strength.color.opacity(0.12))
                    .clipShape(Capsule())
                }
            }
            
            // Rules List
            VStack(alignment: .leading, spacing: 8) {
                ruleRow(title: "At least 8 characters", isMet: hasMinLength)
                ruleRow(title: "At least one uppercase letter", isMet: hasUppercase)
                ruleRow(title: "At least one number", isMet: hasNumber)
            }
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Helper Rule Row
    @ViewBuilder
    private func ruleRow(title: String, isMet: Bool) -> some View {
        HStack(spacing: 8) {
            Image(systemName: isMet ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 14))
                .foregroundStyle(isMet ? Color.mcStatusGreen : Color.mcTextSecondary.opacity(0.6))
            
            Text(title)
                .font(.system(size: 13))
                .foregroundStyle(isMet ? Color.mcTextPrimary : Color.mcTextSecondary)
        }
    }
}

#if DEBUG
struct MCPasswordRulesView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            MCPasswordRulesView(password: "pass")
            MCPasswordRulesView(password: "Password")
            MCPasswordRulesView(password: "Password123")
        }
        .padding()
    }
}
#endif
