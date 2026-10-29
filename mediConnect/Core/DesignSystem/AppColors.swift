// AppColors.swift
// MediConnect — Core/DesignSystem
//
// Created for MediConnect iOS design system following Figma specifications.

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Dynamic Color Helper
#if canImport(UIKit)
public extension UIColor {
    static func dynamic(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor { traits in
            traits.userInterfaceStyle == .dark ? dark : light
        }
    }
}
#endif

// MARK: - Design System Colors
public enum AppColors {
    
    // MARK: - Brand Colors (Figma: Teal & Mint)
    /// Primary Brand Teal (#0E5E58) — Used for primary CTA buttons, icons, selected states
    public static let primaryTeal = Color(hex: "0E5E58")
    
    /// Dark Teal (#08403C) — Pressed button state, high contrast header elements
    public static let darkTeal = Color(hex: "08403C")
    
    /// Light Teal / Mint Tint (#E8F5F3) — Card backgrounds, active filters, icon badges
    #if canImport(UIKit)
    public static let lightTeal = Color(UIColor.dynamic(
        light: UIColor(red: 232/255, green: 245/255, blue: 243/255, alpha: 1.0),
        dark: UIColor(red: 19/255, green: 78/255, blue: 74/255, alpha: 0.5)
    ))
    #else
    public static let lightTeal = Color(hex: "E8F5F3")
    #endif
    
    /// Soft Teal Border (#BCE3DE) — Active input border and card outline
    public static let borderTeal = Color(hex: "BCE3DE")
    
    // MARK: - Status Colors
    /// Confirmed / Verified Green (#10B981) — Verified badges, confirmed status
    public static let statusGreen = Color(hex: "10B981")
    
    /// Light Green Pill (#D1FAE5) — Background for confirmed status badges
    #if canImport(UIKit)
    public static let statusGreenLight = Color(UIColor.dynamic(
        light: UIColor(red: 209/255, green: 250/255, blue: 229/255, alpha: 1.0),
        dark: UIColor(red: 6/255, green: 78/255, blue: 59/255, alpha: 0.5)
    ))
    #else
    public static let statusGreenLight = Color(hex: "D1FAE5")
    #endif
    
    /// Warning / Pending Orange (#F59E0B) — Reschedule notices, countdown timers
    public static let statusOrange = Color(hex: "F59E0B")
    
    /// Danger / Cancellation Red (#EF4444) — Cancel button, error banners
    public static let statusRed = Color(hex: "EF4444")
    
    // MARK: - Neutral & Typography Colors
    #if canImport(UIKit)
    /// Primary Text — Main titles, doctor names, high-emphasis text
    public static let textPrimary = Color(UIColor.dynamic(
        light: UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0),
        dark: UIColor.white
    ))
    
    /// Secondary Text — Subtitles, field labels, metadata, descriptions
    public static let textSecondary = Color(UIColor.dynamic(
        light: UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0),
        dark: UIColor(red: 148/255, green: 163/255, blue: 184/255, alpha: 1.0)
    ))
    
    /// Field Label Text — Uppercase field labels above input boxes
    public static let textLabel = Color(UIColor.dynamic(
        light: UIColor(red: 71/255, green: 85/255, blue: 105/255, alpha: 1.0),
        dark: UIColor(red: 203/255, green: 213/255, blue: 225/255, alpha: 1.0)
    ))
    
    /// Card & Surface Background
    public static let cardBackground = Color(UIColor.dynamic(
        light: UIColor.white,
        dark: UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
    ))
    
    /// Input Field Background
    public static let inputBackground = Color(UIColor.dynamic(
        light: UIColor(red: 248/255, green: 250/255, blue: 252/255, alpha: 1.0),
        dark: UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
    ))
    
    /// Light Border — Default unselected border for cards and inputs
    public static let borderLight = Color(UIColor.dynamic(
        light: UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0),
        dark: UIColor(red: 51/255, green: 65/255, blue: 85/255, alpha: 1.0)
    ))
    
    /// App Background
    public static let appBackground = Color(UIColor.dynamic(
        light: UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0),
        dark: UIColor(red: 15/255, green: 23/255, blue: 42/255, alpha: 1.0)
    ))
    #else
    public static let textPrimary = Color(hex: "1E293B")
    public static let textSecondary = Color(hex: "64748B")
    public static let textLabel = Color(hex: "475569")
    public static let cardBackground = Color.white
    public static let inputBackground = Color(hex: "F8FAFC")
    public static let borderLight = Color(hex: "E2E8F0")
    public static let appBackground = Color(hex: "FAFAFA")
    #endif
}

// MARK: - Convenient Color Extension
public extension Color {
    static let mcTeal          = AppColors.primaryTeal
    static let mcTealDark      = AppColors.darkTeal
    static let mcTealLight     = AppColors.lightTeal
    static let mcTealBorder    = AppColors.borderTeal
    static let mcStatusGreen   = AppColors.statusGreen
    static let mcStatusGreenBg = AppColors.statusGreenLight
    static let mcStatusOrange  = AppColors.statusOrange
    static let mcStatusRed     = AppColors.statusRed
    static let mcTextPrimary   = AppColors.textPrimary
    static let mcTextSecondary = AppColors.textSecondary
    static let mcTextLabel     = AppColors.textLabel
    static let mcInputBg       = AppColors.inputBackground
    static let mcBorderLight   = AppColors.borderLight
    static let mcAppBg         = AppColors.appBackground
    static let mcCardBg        = AppColors.cardBackground
}
