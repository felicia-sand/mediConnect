// QueueViewModel.swift
// MediConnect — Features/Queue/ViewModels
//
// Real-time Queue Management Engine (PRD Feature 03 & Figma Page 7):
// - Manages patient token assignment, now serving tracking, and estimated wait duration
// - Synchronizes visual queue track (A-05, A-06, A-07, A-08, A-09, A-10)
// - Provides dynamic queue progression simulation for coursework demonstrations
// - Bridges ActivityKit Live Activities and Dynamic Island updates

import Foundation
import Combine
import SwiftUI

// MARK: - Queue Slot Item
enum QueueSlotStatus: String, Codable {
    case completed       = "completed"
    case inConsultation  = "in_consultation"
    case currentUser     = "current_user"
    case upcoming        = "upcoming"
    
    var displayName: String {
        switch self {
        case .completed:      return "Completed"
        case .inConsultation: return "In Exam"
        case .currentUser:    return "You"
        case .upcoming:       return "In Line"
        }
    }
}

struct QueueSlotItem: Identifiable, Hashable {
    let id: String
    let tokenNumber: String
    var status: QueueSlotStatus
    let timeLabel: String
    let isCurrentUser: Bool
}

// MARK: - QueueViewModel
@MainActor
final class QueueViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var appointment: Appointment
    @Published var nowServingNumber: String = "A-07"
    @Published var nowServingStatus: String = "In Examination · Started 8 mins ago"
    @Published var patientQueueNumber: String = "A-08"
    @Published var peopleAheadCount: Int = 1
    @Published var estimatedWaitMinutes: Int = 8
    @Published var averageMinutesPerPatient: Int = 12
    @Published var isCurrentUserTurn: Bool = false
    
    @Published var clinicName: String = "Lanka Heart Care Clinic"
    @Published var roomNumber: String = "Room 204"
    @Published var doctorName: String = "Dr. Nimal Perera"
    @Published var doctorSpecialty: String = "Cardiologist - Adult Interventional"
    @Published var waitingLounge: String = "Waiting Lounge B · 2nd Floor (Near Room 204)"
    @Published var wifiNetwork: String = "LankaHeart_Guest"
    @Published var wifiPassword: String = "Care@2026"
    
    @Published var queueTrack: [QueueSlotItem] = []
    @Published var isPulsing: Bool = true
    @Published var showTurnAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var lastRefreshed: Date = Date()
    
    // MARK: - Init
    init(appointment: Appointment = Appointment.mockUpcoming) {
        self.appointment = appointment
        self.patientQueueNumber = appointment.queueNumber ?? "A-08"
        self.clinicName = appointment.clinicName
        self.roomNumber = appointment.roomNumber ?? "Room 204"
        if let doctor = appointment.doctor {
            self.doctorName = doctor.user.fullName
            self.doctorSpecialty = doctor.displayTitle
        }
        setupInitialQueueTrack()
    }
    
    // MARK: - Initial Track Setup
    private func setupInitialQueueTrack() {
        self.nowServingNumber = "A-07"
        self.nowServingStatus = "In Examination · Started 8 mins ago"
        self.peopleAheadCount = 1
        self.estimatedWaitMinutes = 8
        self.isCurrentUserTurn = false
        
        self.queueTrack = [
            QueueSlotItem(id: "slot-05", tokenNumber: "A-05", status: .completed, timeLabel: "9:45 AM", isCurrentUser: false),
            QueueSlotItem(id: "slot-06", tokenNumber: "A-06", status: .completed, timeLabel: "10:00 AM", isCurrentUser: false),
            QueueSlotItem(id: "slot-07", tokenNumber: "A-07", status: .inConsultation, timeLabel: "10:15 AM", isCurrentUser: false),
            QueueSlotItem(id: "slot-08", tokenNumber: "A-08", status: .currentUser, timeLabel: "10:30 AM", isCurrentUser: true),
            QueueSlotItem(id: "slot-09", tokenNumber: "A-09", status: .upcoming, timeLabel: "10:45 AM", isCurrentUser: false),
            QueueSlotItem(id: "slot-10", tokenNumber: "A-10", status: .upcoming, timeLabel: "11:00 AM", isCurrentUser: false)
        ]
    }
    
    // MARK: - Real-Time Queue Simulation (Coursework Evaluation Feature)
    /// Advances queue forward: A-07 completes -> A-08 (Current Patient) is summoned
    func advanceQueue() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if nowServingNumber == "A-07" {
                // Summon Current User!
                nowServingNumber = "A-08"
                nowServingStatus = "NOW CALLING · Please enter \(roomNumber)"
                peopleAheadCount = 0
                estimatedWaitMinutes = 0
                isCurrentUserTurn = true
                
                queueTrack = [
                    QueueSlotItem(id: "slot-05", tokenNumber: "A-05", status: .completed, timeLabel: "9:45 AM", isCurrentUser: false),
                    QueueSlotItem(id: "slot-06", tokenNumber: "A-06", status: .completed, timeLabel: "10:00 AM", isCurrentUser: false),
                    QueueSlotItem(id: "slot-07", tokenNumber: "A-07", status: .completed, timeLabel: "10:15 AM", isCurrentUser: false),
                    QueueSlotItem(id: "slot-08", tokenNumber: "A-08", status: .inConsultation, timeLabel: "10:30 AM", isCurrentUser: true),
                    QueueSlotItem(id: "slot-09", tokenNumber: "A-09", status: .upcoming, timeLabel: "10:45 AM", isCurrentUser: false),
                    QueueSlotItem(id: "slot-10", tokenNumber: "A-10", status: .upcoming, timeLabel: "11:00 AM", isCurrentUser: false)
                ]
                
                alertTitle = "It's Your Turn! 🩺"
                alertMessage = "Token \(patientQueueNumber) is now being called by \(doctorName). Please proceed immediately to \(roomNumber)."
                showTurnAlert = true
                
            } else if nowServingNumber == "A-08" {
                // Patient finished examination
                nowServingNumber = "A-09"
                nowServingStatus = "In Examination · Started just now"
                peopleAheadCount = 0
                isCurrentUserTurn = false
                
                queueTrack = [
                    QueueSlotItem(id: "slot-05", tokenNumber: "A-05", status: .completed, timeLabel: "9:45 AM", isCurrentUser: false),
                    QueueSlotItem(id: "slot-06", tokenNumber: "A-06", status: .completed, timeLabel: "10:00 AM", isCurrentUser: false),
                    QueueSlotItem(id: "slot-07", tokenNumber: "A-07", status: .completed, timeLabel: "10:15 AM", isCurrentUser: false),
                    QueueSlotItem(id: "slot-08", tokenNumber: "A-08", status: .completed, timeLabel: "10:30 AM", isCurrentUser: true),
                    QueueSlotItem(id: "slot-09", tokenNumber: "A-09", status: .inConsultation, timeLabel: "10:45 AM", isCurrentUser: false),
                    QueueSlotItem(id: "slot-10", tokenNumber: "A-10", status: .upcoming, timeLabel: "11:00 AM", isCurrentUser: false)
                ]
                
                alertTitle = "Consultation Complete"
                alertMessage = "Your consultation with \(doctorName) has concluded. Prescriptions and medical notes are available in your Profile."
                showTurnAlert = true
            } else {
                // Reset to beginning
                setupInitialQueueTrack()
            }
            
            lastRefreshed = Date()
        }
    }
    
    /// Rewind simulation back to baseline
    func resetSimulation() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            setupInitialQueueTrack()
            lastRefreshed = Date()
        }
    }
}
