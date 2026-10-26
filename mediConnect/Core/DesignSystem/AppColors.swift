// AppColors.swift
// MediConnect — Core/DesignSystem
//
// Created for MediConnect iOS design system following Figma specifications.

import SwiftUI

// MARK: - Design System Colors
public enum AppColors {
    
    // MARK: - Brand Colors (Figma: Teal & Mint)
    /// Primary Brand Teal (#0E5E58) — Used for primary CTA buttons, icons, selected states
    public static let primaryTeal = Color(hex: "0E5E58")
    
    /// Dark Teal (#08403C) — Pressed button state, high contrast header elements
    public static let darkTeal = Color(hex: "08403C")
    
    /// Light Teal / Mint Tint (#E8F5F3) — Card backgrounds, active filters, icon badges
    public static let lightTeal = Color(hex: "E8F5F3")
    
    /// Soft Teal Border (#BCE3DE) — Active input border and card outline
    public static let borderTeal = Color(hex: "BCE3DE")
    
    // MARK: - Status Colors
    /// Confirmed / Verified Green (#10B981) — Verified badges, confirmed status
    public static let statusGreen = Color(hex: "10B981")
    
    /// Light Green Pill (#D1FAE5) — Background for confirmed status badges
    public static let statusGreenLight = Color(hex: "D1FAE5")
    
    /// Warning / Pending Orange (#F59E0B) — Reschedule notices, countdown timers
    public static let statusOrange = Color(hex: "F59E0B")
    
    /// Danger / Cancellation Red (#EF4444) — Cancel button, error banners
    public static let statusRed = Color(hex: "EF4444")
    
    // MARK: - Neutral & Typography Colors
    /// Primary Text (#1E293B) — Main titles, doctor names, high-emphasis text
    public static let textPrimary = Color(hex: "1E293B")
    
    /// Secondary Text (#64748B) — Subtitles, field labels, metadata, descriptions
    public static let textSecondary = Color(hex: "64748B")
    
    /// Field Label Text (#475569) — Uppercase field labels above input boxes
    public static let textLabel = Color(hex: "475569")
    
    /// Card & Surface Background (#FFFFFF)
    public static let cardBackground = Color.white
    
    /// Input Field Background (#F8FAFC) — Soft off-white for text input fields
    public static let inputBackground = Color(hex: "F8FAFC")
    
    /// Light Border (#E2E8F0) — Default unselected border for cards and inputs
    public static let borderLight = Color(hex: "E2E8F0")
    
    /// App Background (#FAFAFA)
    public static let appBackground = Color(hex: "FAFAFA")
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
}
