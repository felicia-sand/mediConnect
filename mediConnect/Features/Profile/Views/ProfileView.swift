// ProfileView.swift
// MediConnect — Features/Profile/Views
//
// User Profile & Settings tab matching Figma specifications (Page 8):
// - Verified patient badge, contact info, and patient identity details
// - Interactive sub-sheets: Personal Information, Saved Doctors, Notification Preferences, Appearance
// - Biometric authentication quick login integration (Face ID / Touch ID)
// - Sign out action returning cleanly to Authentication pipeline

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var notifService = NotificationService.shared
    @StateObject private var biometricService = BiometricAuthService.shared
    
    // Sub-sheet state
    @State private var showPersonalInfoSheet: Bool = false
    @State private var showNotificationSheet: Bool = false
    @State private var showSavedDoctorsSheet: Bool = false
    @State private var showAppearanceSheet: Bool = false
    @State private var showSignOutAlert: Bool = false
    
    @State private var selectedAppearance: String = "System (Light)"
    @State private var isFaceIDEnabled: Bool = true
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    // MARK: - 1. User Header Card
                    userHeaderCard
                        .padding(.top, 16)
                    
                    // MARK: - 2. SECTION: Profile
                    settingsSection(title: "PROFILE") {
                        Button {
                            showPersonalInfoSheet = true
                        } label: {
                            settingsRow(icon: "person.text.rectangle", title: "Personal Information", value: "NIC · Blood Group")
                        }
                        .buttonStyle(.plain)
                        
                        Divider().padding(.leading, 44)
                        
                        Button {
                            showPersonalInfoSheet = true
                        } label: {
                            settingsRow(icon: "slider.horizontal.3", title: "Edit Health Profile", value: "")
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // MARK: - 3. SECTION: Security & Biometrics
                    settingsSection(title: "SECURITY") {
                        HStack(spacing: 12) {
                            Image(systemName: "faceid")
                                .font(.system(size: 16))
                                .foregroundStyle(Color.mcTeal)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Face ID / Biometric Login")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(Color.mcTextPrimary)
                                
                                Text("Quick secure access on launch")
                                    .font(.system(size: 11))
                                    .foregroundStyle(Color.mcTextSecondary)
                            }
                            
                            Spacer()
                            
                            Toggle("", isOn: $isFaceIDEnabled)
                                .labelsHidden()
                                .tint(Color.mcTeal)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    
                    // MARK: - 4. SECTION: Preferences
                    settingsSection(title: "PREFERENCES") {
                        Button {
                            showNotificationSheet = true
                        } label: {
                            settingsRow(icon: "bell", title: "Notifications", value: notifService.isAuthorized ? "Enabled" : "Manage")
                        }
                        .buttonStyle(.plain)
                        
                        Divider().padding(.leading, 44)
                        
                        Button {
                            showSavedDoctorsSheet = true
                        } label: {
                            settingsRow(icon: "bookmark", title: "Saved Doctors", value: "3 Specialists")
                        }
                        .buttonStyle(.plain)
                        
                        Divider().padding(.leading, 44)
                        
                        Button {
                            showAppearanceSheet = true
                        } label: {
                            settingsRow(icon: "sun.max", title: "Appearance", value: selectedAppearance)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // MARK: - 5. SECTION: Notifications & Queue Alerts
                    settingsSection(title: "NOTIFICATIONS") {
                        Button {
                            showNotificationSheet = true
                        } label: {
                            settingsRow(icon: "calendar.badge.clock", title: "Appointment Reminders", value: "24h & 2h Prior")
                        }
                        .buttonStyle(.plain)
                        
                        Divider().padding(.leading, 44)
                        
                        Button {
                            showNotificationSheet = true
                        } label: {
                            settingsRow(icon: "speaker.wave.2", title: "Live Queue Chimes", value: "High Priority")
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // MARK: - 6. SECTION: Account & Sign Out
                    settingsSection(title: "ACCOUNT") {
                        Button {
                            showSignOutAlert = true
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
            .sheet(isPresented: $showPersonalInfoSheet) {
                personalInfoSheetView
            }
            .sheet(isPresented: $showNotificationSheet) {
                notificationSettingsSheetView
            }
            .sheet(isPresented: $showSavedDoctorsSheet) {
                savedDoctorsSheetView
            }
            .sheet(isPresented: $showAppearanceSheet) {
                appearanceSettingsSheetView
            }
            .alert("Sign Out of MediConnect?", isPresented: $showSignOutAlert) {
                Button("Sign Out", role: .destructive) {
                    authViewModel.signOut()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("You will need to enter your password or use Face ID to log back in.")
            }
        }
    }
    
    // MARK: - Subviews
    
    // 1. User Header Card
    private var userHeaderCard: some View {
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
                    Text("Verified Patient · NIC Verified")
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
    
    // MARK: - Sub-Sheet 1: Personal Information
    private var personalInfoSheetView: some View {
        NavigationStack {
            List {
                Section("Identity & Demographics") {
                    infoRow(label: "Full Name", value: "Pasindu Mathsara Gunasekera")
                    infoRow(label: "Sri Lankan NIC", value: "199234509821 (Verified)")
                    infoRow(label: "Date of Birth", value: "14 August 1992 (32 yrs)")
                    infoRow(label: "Gender", value: "Male")
                    infoRow(label: "Blood Group", value: "B Positive (B+)")
                }
                
                Section("Contact & Residence") {
                    infoRow(label: "Mobile", value: "+94 77 123 4567")
                    infoRow(label: "Email", value: "pasindu@example.com")
                    infoRow(label: "Address", value: "No. 24, Flower Road, Colombo 07")
                    infoRow(label: "Province", value: "Western Province")
                }
                
                Section("Emergency Contact") {
                    infoRow(label: "Name", value: "Mrs. Nirmala Mathsara")
                    infoRow(label: "Relationship", value: "Mother")
                    infoRow(label: "Phone", value: "+94 71 987 6543")
                }
            }
            .navigationTitle("Personal Information")
            .inlineNavigationBarTitle()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        showPersonalInfoSheet = false
                    }
                }
            }
        }
    }
    
    // MARK: - Sub-Sheet 2: Notification Preferences
    private var notificationSettingsSheetView: some View {
        NavigationStack {
            Form {
                Section("General Notifications") {
                    Toggle("Push Notifications", isOn: $notifService.pushNotificationsEnabled)
                        .tint(Color.mcTeal)
                    Toggle("SMS Reminders", isOn: $notifService.smsRemindersEnabled)
                        .tint(Color.mcTeal)
                }
                
                Section("Queue & Arrival Alerts") {
                    Toggle("Queue Turn Chimes", isOn: $notifService.queueChimeAlertsEnabled)
                        .tint(Color.mcTeal)
                    Toggle("Clinic Geofence Detection", isOn: $notifService.proximityAlertsEnabled)
                        .tint(Color.mcTeal)
                }
                
                Section {
                    Button("Request Notification Permissions") {
                        notifService.requestAuthorization()
                    }
                    .foregroundStyle(Color.mcTeal)
                } footer: {
                    Text("MediConnect uses notifications to remind you 24h & 2h before appointments and to sound high-priority chimes when the doctor summons your token.")
                }
            }
            .navigationTitle("Notification Settings")
            .inlineNavigationBarTitle()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        showNotificationSheet = false
                    }
                }
            }
        }
    }
    
    // MARK: - Sub-Sheet 3: Saved Doctors
    private var savedDoctorsSheetView: some View {
        NavigationStack {
            List {
                ForEach(Doctor.mockDoctors) { doctor in
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.mcTealLight)
                                .frame(width: 44, height: 44)
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(Color.mcTeal)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(doctor.user.fullName)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(Color.mcTextPrimary)
                            
                            Text(doctor.displayTitle)
                                .font(.system(size: 12))
                                .foregroundStyle(Color.mcTextSecondary)
                            
                            Text(doctor.hospital)
                                .font(.system(size: 11))
                                .foregroundStyle(Color.mcTeal)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "bookmark.fill")
                            .foregroundStyle(Color.mcTeal)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Saved Specialists")
            .inlineNavigationBarTitle()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        showSavedDoctorsSheet = false
                    }
                }
            }
        }
    }
    
    // MARK: - Sub-Sheet 4: Appearance Settings
    private var appearanceSettingsSheetView: some View {
        NavigationStack {
            Form {
                Section("Theme Mode") {
                    ForEach(["System (Light)", "Light Mode", "Dark Mode"], id: \.self) { theme in
                        HStack {
                            Text(theme)
                                .foregroundStyle(Color.mcTextPrimary)
                            Spacer()
                            if selectedAppearance == theme {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.mcTeal)
                                    .font(.system(size: 14, weight: .bold))
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedAppearance = theme
                        }
                    }
                }
            }
            .navigationTitle("Appearance")
            .inlineNavigationBarTitle()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        showAppearanceSheet = false
                    }
                }
            }
        }
    }
    
    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.mcTextSecondary)
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.mcTextPrimary)
        }
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
