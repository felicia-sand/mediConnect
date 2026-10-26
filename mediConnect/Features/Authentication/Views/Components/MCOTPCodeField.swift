// MCOTPCodeField.swift
// MediConnect — Features/Authentication/Views/Components
//
// 6-digit OTP verification code component matching Figma:
// - Individual rounded digit boxes
// - Auto-advancing focus
// - Active box highlighted with primary teal border
// - Supports numeric keypad and clipboard paste

import SwiftUI

public struct MCOTPCodeField: View {
    
    // MARK: - Properties
    public let codeLength: Int
    @Binding public var code: String
    
    // MARK: - Focus State
    @FocusState private var isFocused: Bool
    
    // MARK: - Init
    public init(codeLength: Int = 6, code: Binding<String>) {
        self.codeLength = codeLength
        self._code = code
    }
    
    // MARK: - Body
    public var body: some View {
        ZStack {
            // Invisible underlying TextField capturing keyboard input
            TextField("", text: $code)
                #if os(iOS)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                #endif
                .focused($isFocused)
                .opacity(0.01)
                .onChange(of: code) { _, newValue in
                    let filtered = newValue.filter { $0.isNumber }
                    if filtered.count > codeLength {
                        code = String(filtered.prefix(codeLength))
                    } else if filtered != newValue {
                        code = filtered
                    }
                }
            
            // Visible 6-digit segmented boxes
            HStack(spacing: 10) {
                ForEach(0..<codeLength, id: \.self) { index in
                    digitBox(for: index)
                }
            }
        }
        .onTapGesture {
            isFocused = true
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isFocused = true
            }
        }
    }
    
    // MARK: - Digit Box View
    @ViewBuilder
    private func digitBox(for index: Int) -> some View {
        let charArray = Array(code)
        let hasCharacter = index < charArray.count
        let isCurrentActiveIndex = index == charArray.count && isFocused
        
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.mcInputBg)
            
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    isCurrentActiveIndex || hasCharacter ? Color.mcTeal : Color.mcBorderLight,
                    lineWidth: isCurrentActiveIndex ? 2 : 1
                )
            
            if hasCharacter {
                Text(String(charArray[index]))
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(Color.mcTextPrimary)
            } else if isCurrentActiveIndex {
                // Pulsing cursor indicator
                Rectangle()
                    .fill(Color.mcTeal)
                    .frame(width: 2, height: 20)
            }
        }
        .frame(width: 46, height: 54)
    }
}

#if DEBUG
struct MCOTPCodeField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            MCOTPCodeField(code: .constant("482"))
            MCOTPCodeField(code: .constant("482910"))
        }
        .padding()
    }
}
#endif
