// BookingViewModel.swift
// MediConnect — Features/Appointments/ViewModels
//
// ViewModel managing the multi-step Appointment Booking pipeline:
// 1. Patient Details validation (Sri Lankan NIC, +94 Contact, Address)
// 2. Booking Review & Cost Breakdown
// 3. Appointment Confirmation & Slot Locking
// 4. Rescheduling and Cancellation Lifecycle

import Foundation
import SwiftUI
import Combine

@MainActor
final class BookingViewModel: ObservableObject {
    
    // MARK: - Selected Doctor & Slot
    @Published var doctor: Doctor?
    @Published var selectedDate: Date = Date()
    @Published var selectedSlot: TimeSlot?
    
    // MARK: - Patient Details Form (Figma Page 6)
    @Published var patientFullName: String = ""
    @Published var patientAge: String = ""
    @Published var patientGender: String = "Male"
    @Published var nicOrPassport: String = ""
    @Published var contactNumber: String = ""
    @Published var homeAddress: String = ""
    @Published var additionalNotes: String = ""
    
    // MARK: - Status & Navigation
    @Published var isSubmitting: Bool = false
    @Published var errorMessage: String?
    @Published var isBookingConfirmed: Bool = false
    @Published var confirmedAppointment: Appointment?
    
    // MARK: - Cancellation & Reschedule State
    @Published var showCancelConfirmation: Bool = false
    @Published var showRescheduleSheet: Bool = false
    
    // MARK: - Fee Calculation
    var consultationFee: Double {
        doctor?.consultationFee ?? 3500
    }
    
    var hospitalServiceFee: Double {
        250.0
    }
    
    var totalFee: Double {
        consultationFee + hospitalServiceFee
    }
    
    var formattedConsultationFee: String {
        String(format: "Rs. %.0f", consultationFee)
    }
    
    var formattedServiceFee: String {
        String(format: "Rs. %.0f", hospitalServiceFee)
    }
    
    var formattedTotalFee: String {
        String(format: "Rs. %.0f", totalFee)
    }
    
    // MARK: - Validation
    var isNICValid: Bool {
        let trimmed = nicOrPassport.trimmingCharacters(in: .whitespaces).uppercased()
        if trimmed.isEmpty { return false }
        
        // Old NIC: 9 digits followed by V or X (e.g. 923450982V)
        let oldNICRegex = "^[0-9]{9}[VvXx]$"
        // New NIC: 12 digits (e.g. 199234509821)
        let newNICRegex = "^[0-9]{12}$"
        // Passport: 1-2 letters + 7 digits
        let passportRegex = "^[A-Z]{1,2}[0-9]{7,8}$"
        
        let oldPred = NSPredicate(format: "SELF MATCHES %@", oldNICRegex)
        let newPred = NSPredicate(format: "SELF MATCHES %@", newNICRegex)
        let passPred = NSPredicate(format: "SELF MATCHES %@", passportRegex)
        
        return oldPred.evaluate(with: trimmed) || newPred.evaluate(with: trimmed) || passPred.evaluate(with: trimmed)
    }
    
    var isPhoneValid: Bool {
        let cleaned = contactNumber.filter { $0.isNumber }
        return cleaned.count >= 9
    }
    
    var isPatientDetailsValid: Bool {
        !patientFullName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !patientAge.trimmingCharacters(in: .whitespaces).isEmpty &&
        isNICValid &&
        isPhoneValid &&
        !homeAddress.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    // MARK: - Init
    init(doctor: Doctor? = nil, date: Date = Date(), slot: TimeSlot? = nil, user: User? = nil) {
        self.doctor = doctor
        self.selectedDate = date
        self.selectedSlot = slot
        
        // Pre-fill user details if available
        if let user = user {
            self.patientFullName = user.fullName
            self.contactNumber = user.phoneNumber ?? "077 123 4567"
        } else {
            self.patientFullName = "Pasindu Mathsara"
            self.patientAge = "29"
            self.patientGender = "Male"
            self.nicOrPassport = "199512304567"
            self.contactNumber = "077 123 4567"
            self.homeAddress = "No. 24, Flower Road, Colombo 07"
        }
    }
    
    // MARK: - Setup from Doctor Profile
    func configure(doctor: Doctor, date: Date, slot: TimeSlot?) {
        self.doctor = doctor
        self.selectedDate = date
        self.selectedSlot = slot
    }
    
    // MARK: - Confirm Booking Action
    func confirmBooking() async {
        guard isPatientDetailsValid else {
            if !isNICValid {
                errorMessage = "Please enter a valid Sri Lankan NIC (e.g. 199234509821 or 923450982V) or Passport number."
            } else if !isPhoneValid {
                errorMessage = "Please enter a valid 9 or 10-digit contact number."
            } else {
                errorMessage = "Please fill in all required fields."
            }
            return
        }
        
        isSubmitting = true
        errorMessage = nil
        
        do {
            // Simulated network/Firestore write delay
            try await Task.sleep(nanoseconds: 900_000_000)
            
            let targetDoctor = doctor ?? Doctor.mockDoctors[0]
            let slotTimeString = selectedSlot?.timeString ?? "4:00 PM"
            
            let newAppointment = Appointment(
                id: "appt-" + UUID().uuidString.prefix(6).lowercased(),
                patientId: "user-001",
                doctorId: targetDoctor.id,
                doctor: targetDoctor,
                clinicName: targetDoctor.clinicName,
                clinicAddress: targetDoctor.hospital,
                roomNumber: "Room 204",
                scheduledDate: selectedDate,
                durationMinutes: 20,
                type: .inPerson,
                status: .confirmed,
                reason: additionalNotes.isEmpty ? "Consultation with specialist" : additionalNotes,
                notes: "Slot: \(slotTimeString) · NIC: \(nicOrPassport) · Phone: +94 \(contactNumber)",
                queueNumber: "A-08",
                peopleAheadCount: 1,
                estimatedWaitMinutes: 10,
                isCheckedIn: true,
                checkInTime: Date(),
                createdAt: Date()
            )
            
            self.confirmedAppointment = newAppointment
            self.isBookingConfirmed = true
        } catch {
            errorMessage = "Booking failed. The selected slot may no longer be available. Please try another time."
        }
        
        isSubmitting = false
    }
    
    // MARK: - Cancel Appointment Action
    func cancelAppointment() async {
        isSubmitting = true
        errorMessage = nil
        
        do {
            try await Task.sleep(nanoseconds: 600_000_000)
            if var appt = confirmedAppointment {
                appt.status = .cancelled
                self.confirmedAppointment = appt
            }
            showCancelConfirmation = false
        } catch {
            errorMessage = "Could not cancel appointment. Please contact clinic support."
        }
        
        isSubmitting = false
    }
}
