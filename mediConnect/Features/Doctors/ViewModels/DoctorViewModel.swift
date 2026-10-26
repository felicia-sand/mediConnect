// DoctorViewModel.swift
// MediConnect — Features/Doctors/ViewModels
//
// ViewModel managing Doctor Discovery, Filtering, Sorting, and Slot Selection.
// Follows MVVM architecture and Figma page 5 specifications.

import Foundation
import SwiftUI
import Combine

// MARK: - Sort Option
enum DoctorSortOption: String, CaseIterable, Identifiable {
    case distance = "Distance"
    case rating   = "Rating"
    case fee      = "Consultation Fee"
    
    var id: String { rawValue }
}

// MARK: - Calendar Day Item
struct BookingDay: Identifiable, Hashable {
    let id: String
    let dayName: String    // e.g. "MON", "TUE"
    let dayNumber: String  // e.g. "25", "26"
    let date: Date
}

@MainActor
final class DoctorViewModel: ObservableObject {
    
    // MARK: - Published Search & Filter State
    @Published var allDoctors: [Doctor] = []
    @Published var searchText: String = ""
    @Published var selectedSpecialty: Specialization? = .cardiology
    @Published var maxDistanceKm: Double? = 5.0
    @Published var onlyNextAvailable: Bool = false
    @Published var sortOption: DoctorSortOption = .distance
    
    // MARK: - Doctor Profile & Booking Selection State
    @Published var selectedDoctor: Doctor?
    @Published var selectedDate: Date = Date()
    @Published var selectedTimeSlot: TimeSlot?
    @Published var availableDays: [BookingDay] = []
    @Published var availableSlots: [TimeSlot] = []
    
    // MARK: - Init
    init() {
        loadDoctors()
        generateBookingDays()
    }
    
    // MARK: - Data Loading
    func loadDoctors() {
        self.allDoctors = Doctor.mockDoctors
        if let firstDoc = allDoctors.first {
            self.selectedDoctor = firstDoc
            self.availableSlots = firstDoc.availableSlots
            self.selectedTimeSlot = firstDoc.availableSlots.first(where: { $0.isSelected })
        }
    }
    
    // MARK: - Computed Filtered Doctors
    var filteredDoctors: [Doctor] {
        var results = allDoctors
        
        // Search Filter
        let query = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        if !query.isEmpty {
            results = results.filter { doc in
                doc.user.fullName.lowercased().contains(query) ||
                doc.hospital.lowercased().contains(query) ||
                doc.clinicName.lowercased().contains(query) ||
                (doc.subSpecialty?.lowercased().contains(query) ?? false) ||
                doc.specialization.rawValue.lowercased().contains(query)
            }
        }
        
        // Specialty Filter
        if let specialty = selectedSpecialty {
            results = results.filter { $0.specialization == specialty }
        }
        
        // Distance Filter
        if let maxDist = maxDistanceKm {
            results = results.filter { $0.distanceKm <= maxDist }
        }
        
        // Sorting
        switch sortOption {
        case .distance:
            results.sort { $0.distanceKm < $1.distanceKm }
        case .rating:
            results.sort { $0.rating > $1.rating }
        case .fee:
            results.sort { $0.consultationFee < $1.consultationFee }
        }
        
        return results
    }
    
    var activeFilterCount: Int {
        var count = 0
        if selectedSpecialty != nil { count += 1 }
        if maxDistanceKm != nil { count += 1 }
        if onlyNextAvailable { count += 1 }
        return count
    }
    
    // MARK: - Booking Days Generator
    func generateBookingDays() {
        let calendar = Calendar.current
        var days: [BookingDay] = []
        let today = Date()
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE" // e.g. "Mon"
        
        let numberFormatter = DateFormatter()
        numberFormatter.dateFormat = "d" // e.g. "25"
        
        for offset in 0..<5 {
            if let targetDate = calendar.date(byAdding: .day, value: offset, to: today) {
                let dayName = dayFormatter.string(from: targetDate).uppercased()
                let dayNumber = numberFormatter.string(from: targetDate)
                let dayItem = BookingDay(
                    id: "day-\(offset)",
                    dayName: dayName,
                    dayNumber: dayNumber,
                    date: targetDate
                )
                days.append(dayItem)
            }
        }
        
        self.availableDays = days
        if let first = days.first {
            self.selectedDate = first.date
        }
    }
    
    // MARK: - Slot Selection
    func selectDoctor(_ doctor: Doctor) {
        self.selectedDoctor = doctor
        self.availableSlots = doctor.availableSlots
        self.selectedTimeSlot = doctor.availableSlots.first(where: { !$0.isBooked })
    }
    
    func selectDay(_ day: BookingDay) {
        self.selectedDate = day.date
    }
    
    func selectSlot(_ slot: TimeSlot) {
        guard !slot.isBooked else { return }
        self.selectedTimeSlot = slot
    }
}
