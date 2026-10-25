// Doctor.swift
// MediConnect — Models
//
// Created by Felicia on 25/10/2026.

import Foundation

// MARK: - Specialization
enum Specialization: String, Codable, CaseIterable {
    case generalPhysician  = "General Physician"
    case cardiologist      = "Cardiologist"
    case dermatologist     = "Dermatologist"
    case neurologist       = "Neurologist"
    case pediatrician      = "Pediatrician"
    case orthopedic        = "Orthopedic"
    case psychiatrist      = "Psychiatrist"
    case ophthalmologist   = "Ophthalmologist"
    case gynecologist      = "Gynecologist"
    case dentist           = "Dentist"
    
    var icon: String {
        switch self {
        case .generalPhysician:  return "stethoscope"
        case .cardiologist:      return "heart.fill"
        case .dermatologist:     return "bandage.fill"
        case .neurologist:       return "brain.head.profile"
        case .pediatrician:      return "figure.and.child.holdinghands"
        case .orthopedic:        return "figure.walk"
        case .psychiatrist:      return "brain"
        case .ophthalmologist:   return "eye.fill"
        case .gynecologist:      return "cross.case.fill"
        case .dentist:           return "mouth.fill"
        }
    }
}

// MARK: - Doctor Model
struct Doctor: Identifiable, Codable, Hashable {
    let id: String
    var user: User
    var specialization: Specialization
    var hospital: String
    var yearsOfExperience: Int
    var rating: Double
    var reviewCount: Int
    var consultationFee: Double
    var availableSlots: [TimeSlot]
    var bio: String
    var isAvailableForVideo: Bool
    
    var formattedFee: String {
        String(format: "$%.0f", consultationFee)
    }
    
    var formattedRating: String {
        String(format: "%.1f", rating)
    }
}

// MARK: - TimeSlot
struct TimeSlot: Identifiable, Codable, Hashable {
    let id: String
    var date: Date
    var startTime: String
    var endTime: String
    var isBooked: Bool
}

// MARK: - Mock Data
extension Doctor {
    static let mockDoctors: [Doctor] = [
        Doctor(
            id: "doc-001",
            user: User(id: "user-doc-001", fullName: "Dr. Emily Carter",
                       email: "emily.carter@mediconnect.com", role: .doctor, createdAt: Date()),
            specialization: .cardiologist,
            hospital: "St. Mary's Medical Center",
            yearsOfExperience: 12,
            rating: 4.9,
            reviewCount: 238,
            consultationFee: 150,
            availableSlots: [],
            bio: "Board-certified cardiologist with over 12 years of experience in interventional cardiology and heart failure management.",
            isAvailableForVideo: true
        ),
        Doctor(
            id: "doc-002",
            user: User(id: "user-doc-002", fullName: "Dr. James Wilson",
                       email: "james.wilson@mediconnect.com", role: .doctor, createdAt: Date()),
            specialization: .generalPhysician,
            hospital: "City Health Clinic",
            yearsOfExperience: 8,
            rating: 4.7,
            reviewCount: 145,
            consultationFee: 80,
            availableSlots: [],
            bio: "Experienced general physician focused on preventive care and chronic disease management.",
            isAvailableForVideo: true
        )
    ]
}
