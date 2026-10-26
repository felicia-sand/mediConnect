// Appointment.swift
// MediConnect — Models
//
// Appointment model conforming to Figma screens and queue management PRD specifications.

import Foundation

// MARK: - Appointment Status
enum AppointmentStatus: String, Codable {
    case pending     = "pending"
    case confirmed   = "confirmed"
    case completed   = "completed"
    case cancelled   = "cancelled"
    case rescheduled = "rescheduled"
    
    var displayName: String { rawValue.capitalized }
    
    var icon: String {
        switch self {
        case .pending:     return "clock.fill"
        case .confirmed:   return "checkmark.circle.fill"
        case .completed:   return "checkmark.seal.fill"
        case .cancelled:   return "xmark.circle.fill"
        case .rescheduled: return "arrow.clockwise.circle.fill"
        }
    }
}

// MARK: - Appointment Type
enum AppointmentType: String, Codable {
    case inPerson = "in_person"
    case video    = "video"
    
    var displayName: String {
        switch self {
        case .inPerson: return "In-Person"
        case .video:    return "Video Call"
        }
    }
    
    var icon: String {
        switch self {
        case .inPerson: return "cross.case.fill"
        case .video:    return "video.fill"
        }
    }
}

// MARK: - Appointment Model
struct Appointment: Identifiable, Codable, Hashable {
    let id: String
    var patientId: String
    var doctorId: String
    var doctor: Doctor?
    var clinicName: String
    var clinicAddress: String
    var roomNumber: String?
    var scheduledDate: Date
    var durationMinutes: Int
    var type: AppointmentType
    var status: AppointmentStatus
    var reason: String
    var notes: String?
    var queueNumber: String?
    var peopleAheadCount: Int
    var estimatedWaitMinutes: Int
    var isCheckedIn: Bool
    var checkInTime: Date?
    var createdAt: Date
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: scheduledDate)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: scheduledDate)
    }
    
    var formattedHeroSchedule: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM 'at' h:mm a"
        return formatter.string(from: scheduledDate)
    }
    
    var isUpcoming: Bool {
        status == .confirmed || status == .pending || status == .rescheduled
    }
}

// MARK: - Mock Data (Figma Page 4 & 6)
extension Appointment {
    static let mockUpcoming: Appointment = {
        let calendar = Calendar.current
        var comps = calendar.dateComponents([.year, .month, .day], from: Date())
        comps.hour = 10
        comps.minute = 30
        let date = calendar.date(from: comps) ?? Date()
        
        return Appointment(
            id: "appt-001",
            patientId: "user-001",
            doctorId: "doc-001",
            doctor: Doctor.mockDoctors.first,
            clinicName: "Lanka Heart Care Clinic",
            clinicAddress: "No. 45, Galle Road, Colombo 05",
            roomNumber: "Room 204",
            scheduledDate: date,
            durationMinutes: 30,
            type: .inPerson,
            status: .confirmed,
            reason: "Routine cardiac evaluation and ECG review",
            notes: "Mild exertion palpitations",
            queueNumber: "A-08",
            peopleAheadCount: 1,
            estimatedWaitMinutes: 10,
            isCheckedIn: true,
            checkInTime: Date().addingTimeInterval(-600),
            createdAt: Date()
        )
    }()
    
    static let mockHistory: [Appointment] = [
        mockUpcoming,
        Appointment(
            id: "appt-002",
            patientId: "user-001",
            doctorId: "doc-002",
            doctor: Doctor.mockDoctors[1],
            clinicName: "Asiri Central Health Care",
            clinicAddress: "Norris Canal Rd, Colombo 10",
            roomNumber: "Suite 12",
            scheduledDate: Date().addingTimeInterval(-86400 * 14),
            durationMinutes: 20,
            type: .inPerson,
            status: .completed,
            reason: "Annual wellness checkup",
            notes: "Normal blood pressure, cholesterol profile advised",
            queueNumber: "B-03",
            peopleAheadCount: 0,
            estimatedWaitMinutes: 0,
            isCheckedIn: true,
            checkInTime: nil,
            createdAt: Date().addingTimeInterval(-86400 * 20)
        )
    ]
}
