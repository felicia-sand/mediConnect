// MainTabView.swift
// MediConnect — Features/Dashboard/Views
//
// Persistent 5-Tab Navigation Shell matching Figma & PRD specifications:
// 1. Home
// 2. Doctors
// 3. Appointments
// 4. Map
// 5. Profile

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab: Tab = .home
    @EnvironmentObject var authViewModel: AuthViewModel
    
    enum Tab: Int {
        case home = 0
        case doctors = 1
        case appointments = 2
        case map = 3
        case profile = 4
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // Tab 1: Home Dashboard
            HomeView(onTabSelect: { index in
                if let tab = Tab(rawValue: index) {
                    selectedTab = tab
                }
            })
            .tabItem {
                Label("Home", systemImage: selectedTab == .home ? "house.fill" : "house")
            }
            .tag(Tab.home)
            
            // Tab 2: Doctor Search & Booking
            DoctorsListView()
                .tabItem {
                    Label("Doctors", systemImage: "stethoscope")
                }
                .tag(Tab.doctors)
            
            // Tab 3: Appointments & Queue
            AppointmentsListView()
                .tabItem {
                    Label("Appointments", systemImage: selectedTab == .appointments ? "calendar.badge.clock" : "calendar")
                }
                .tag(Tab.appointments)
            
            // Tab 4: Clinic Discovery Map
            ClinicsMapView()
                .tabItem {
                    Label("Map", systemImage: selectedTab == .map ? "map.fill" : "map")
                }
                .tag(Tab.map)
            
            // Tab 5: Patient Profile & Settings
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: selectedTab == .profile ? "person.crop.circle.fill" : "person.crop.circle")
                }
                .tag(Tab.profile)
        }
        .tint(Color.mcTeal)
    }
}

#if DEBUG
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(AuthViewModel())
    }
}
#endif
