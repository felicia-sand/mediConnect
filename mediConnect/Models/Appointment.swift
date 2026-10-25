// Appointment.swift
// MediConnect — Models
//
// Created by Felicia on 25/10/2026.

import Foundation

// MARK: - Appointment Status
enum AppointmentStatus: String, Codable {
    case pending    = "pending"
    case confirmed  = "confirmed"
    case completed  = "completed"
    case cancelled  = "cancelled"
    case rescheduled = "rescheduled"
    
    var displayName: String { rawValue.capitalized }
    
    var color: String {
        switch self {
        case .pending:      return "orange"
        case .confirmed:    return "blue"
        case .completed:    return "green"
        case .cancelled:    return "red"
        case .rescheduled:  return "purple"
        }
    }
    
    var icon: String {
        switch self {
        case .pending:      return "clock.fill"
        case .confirmed:    return "checkmark.circle.fill"
        case .completed:    return "checkmark.seal.fill"
        case .cancelled:    return "xmark.circle.fill"
        case .rescheduled:  return "arrow.clockwise.circle.fill"
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
    var scheduledDate: Date
    var duration: Int  // in minutes
    var type: AppointmentType
    var status: AppointmentStatus
    var reason: String
    var notes: String?
    var createdAt: Date
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: scheduledDate)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: scheduledDate)
    }
    
    var isUpcoming: Bool {
        scheduledDate > Date() && status == .confirmed
    }
}
