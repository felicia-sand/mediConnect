// ProfileView.swift
// MediConnect — Features/Profile/Views
//
// User Profile & Settings tab matching Figma specifications:
// - Verified patient badge and contact info
// - Profile, Preferences, and Notification settings
// - Sign out action returning to Login flow

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    // User Header Card
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.mcTealLight)
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 74))
                                .foregroundStyle(Color.mcTeal)
                        }
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 3)
                        )
                        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                        
                        VStack(spacing: 4) {
                            Text(authViewModel.currentUser?.fullName ?? "Pasindu Mathsara")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(Color.mcTextPrimary)
                            
                            Text(authViewModel.currentUser?.email ?? "pasindu@example.com")
                                .font(.system(size: 13))
                                .foregroundStyle(Color.mcTextSecondary)
                            
                            // Verified Patient Badge
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(Color.mcStatusGreen)
                                    .frame(width: 6, height: 6)
                                Text("Verified Patient")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundStyle(Color.mcStatusGreen)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.mcStatusGreenBg)
                            .clipShape(Capsule())
                            .padding(.top, 4)
                        }
                    }
                    .padding(.top, 16)
                    
                    // SECTION: Profile
                    settingsSection(title: "PROFILE") {
                        settingsRow(icon: "person.text.rectangle", title: "Personal Information", value: "Basic Details")
                        Divider().padding(.leading, 44)
                        settingsRow(icon: "slider.horizontal.3", title: "Edit Profile", value: "")
                    }
                    
                    // SECTION: Preferences
                    settingsSection(title: "PREFERENCES") {
                        settingsRow(icon: "bell", title: "Notifications", value: "Enabled")
                        Divider().padding(.leading, 44)
                        settingsRow(icon: "bookmark", title: "Saved Doctors", value: "3 Specialists")
                        Divider().padding(.leading, 44)
                        settingsRow(icon: "sun.max", title: "Appearance", value: "System (Light)")
                    }
                    
                    // SECTION: Notifications
                    settingsSection(title: "NOTIFICATIONS") {
                        settingsRow(icon: "calendar.badge.clock", title: "Appointment Reminders", value: "Push & SMS")
                        Divider().padding(.leading, 44)
                        settingsRow(icon: "switch.2", title: "Notification Preferences", value: "Standard")
                    }
                    
                    // SECTION: Account & Sign Out
                    settingsSection(title: "ACCOUNT") {
                        Button {
                            authViewModel.signOut()
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.mcStatusRed)
                                    .frame(width: 24)
                                
                                Text("Sign Out")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(Color.mcStatusRed)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Profile & Settings")
            .inlineNavigationBarTitle()
            .background(Color.mcAppBg.ignoresSafeArea())
        }
    }
    
    // Helper Section Card Builder
    @ViewBuilder
    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(Color.mcTextLabel)
                .tracking(0.5)
                .padding(.leading, 4)
            
            VStack(spacing: 0) {
                content()
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.mcBorderLight, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 1)
        }
    }
    
    // Helper Row Builder
    @ViewBuilder
    private func settingsRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(Color.mcTeal)
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.mcTextPrimary)
            
            Spacer()
            
            if !value.isEmpty {
                Text(value)
                    .font(.system(size: 13))
                    .foregroundStyle(Color.mcTextSecondary)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(Color.mcTextSecondary.opacity(0.6))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
    }
}
#endif
