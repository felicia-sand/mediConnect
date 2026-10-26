// HomeViewModel.swift
// MediConnect — Features/Dashboard/ViewModels
//
// ViewModel managing state and data for the Home Dashboard screen.
// Strictly adheres to MVVM architecture and Figma specifications.

import Foundation
import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var nextAppointment: Appointment?
    @Published var specialties: [Specialization] = []
    @Published var selectedSpecialty: Specialization? = .cardiology
    @Published var nearbyClinics: [Clinic] = []
    @Published var isLoading: Bool = false
    
    // MARK: - Init
    init() {
        loadDashboardData()
    }
    
    // MARK: - Greeting
    func greeting(for user: User?) -> String {
        let name = user?.firstName ?? "Pasindu"
        let hour = Calendar.current.component(.hour, from: Date())
        
        if hour < 12 {
            return "Good morning, \(name)"
        } else if hour < 17 {
            return "Good afternoon, \(name)"
        } else {
            return "Good evening, \(name)"
        }
    }
    
    // MARK: - Data Loading
    func loadDashboardData() {
        isLoading = true
        
        // Load initial data (matching Figma page 4)
        self.nextAppointment = Appointment.mockUpcoming
        self.specialties = Specialization.allCases
        self.nearbyClinics = Clinic.mockClinics
        
        isLoading = false
    }
    
    // MARK: - User Actions
    func selectSpecialty(_ specialty: Specialization) {
        if selectedSpecialty == specialty {
            selectedSpecialty = nil
        } else {
            selectedSpecialty = specialty
        }
    }
}
