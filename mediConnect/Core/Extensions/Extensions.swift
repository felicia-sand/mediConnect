// Extensions.swift
// MediConnect — Core/Extensions
//
// Created by Felicia on 25/10/2026.

import SwiftUI
import Foundation
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Color Extensions
extension Color {
    
    /// MediConnect brand colors
    static let mcBlue    = Color(hex: "2563EB")
    static let mcCyan    = Color(hex: "06B6D4")
    static let mcGreen   = Color(hex: "10B981")
    static let mcRed     = Color(hex: "EF4444")
    static let mcOrange  = Color(hex: "F97316")
    static let mcPurple  = Color(hex: "8B5CF6")
    
    /// Initialize Color from hex string
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >>  8) & 0xFF) / 255
        let b = Double( rgb        & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Date Extensions
extension Date {
    
    var isToday: Bool { Calendar.current.isDateInToday(self) }
    var isTomorrow: Bool { Calendar.current.isDateInTomorrow(self) }
    var isPast: Bool { self < Date() }
    
    func formatted(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    var relativeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    var friendlyDate: String {
        if isToday    { return "Today" }
        if isTomorrow { return "Tomorrow" }
        return formatted("MMM d, yyyy")
    }
}

// MARK: - String Extensions
extension String {
    
    var isValidEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var isValidPhone: Bool {
        let cleaned = filter { $0.isNumber }
        return cleaned.count >= 10
    }
    
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}

// MARK: - View Extensions
extension View {
    
    /// Apply a card-style background
    func cardStyle(cornerRadius: CGFloat = 16) -> some View {
        self
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
    
    /// Hide keyboard on tap
    func hideKeyboardOnTap() -> some View {
        #if canImport(UIKit)
        return self.onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil, from: nil, for: nil
            )
        }
        #else
        return self
        #endif
    }
    
    /// Conditional modifier
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool,
                                transform: (Self) -> Transform) -> some View {
        if condition { transform(self) } else { self }
    }
}
