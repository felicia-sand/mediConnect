// MainTabView.swift
// MediConnect — Features/Dashboard/Views
//
// Created by Felicia on 25/10/2026.

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab: Tab = .home
    
    enum Tab: Int {
        case home, appointments, messages, profile
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: selectedTab == .home ? "house.fill" : "house")
                }
                .tag(Tab.home)
            
            AppointmentsView()
                .tabItem {
                    Label("Appointments", systemImage: selectedTab == .appointments ? "calendar.badge.clock" : "calendar")
                }
                .tag(Tab.appointments)
            
            MessagesView()
                .tabItem {
                    Label("Messages", systemImage: selectedTab == .messages ? "message.fill" : "message")
                }
                .tag(Tab.messages)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: selectedTab == .profile ? "person.fill" : "person")
                }
                .tag(Tab.profile)
        }
        .tint(.blue)
    }
}

// MARK: - Placeholder Views (to be implemented)

struct HomeView: View {
    var body: some View {
        NavigationStack {
            Text("Home Dashboard")
                .navigationTitle("MediConnect")
        }
    }
}

struct AppointmentsView: View {
    var body: some View {
        NavigationStack {
            Text("My Appointments")
                .navigationTitle("Appointments")
        }
    }
}

struct MessagesView: View {
    var body: some View {
        NavigationStack {
            Text("Messages")
                .navigationTitle("Messages")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            Text("My Profile")
                .navigationTitle("Profile")
        }
    }
}

#if DEBUG
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
#endif
