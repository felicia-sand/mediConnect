// Doctor.swift
// MediConnect — Models
//
// Doctor profile entity conforming to Figma screens and Sri Lankan healthcare context.

import Foundation

// MARK: - Specialization
enum Specialization: String, Codable, CaseIterable {
    case cardiology        = "Cardiology"
    case generalPractice   = "General Practice"
    case dermatology       = "Dermatology"
    case pediatrics        = "Pediatrics"
    case neurology         = "Neurology"
    case orthopedics       = "Orthopedics"
    case psychiatry        = "Psychiatry"
    case ophthalmology     = "Ophthalmology"
    case gynecology        = "Gynecology"
    case dentistry         = "Dentistry"
    
    var icon: String {
        switch self {
        case .cardiology:       return "suit.heart.fill"
        case .generalPractice:  return "stethoscope"
        case .dermatology:      return "bandage.fill"
        case .pediatrics:       return "figure.and.child.holdinghands"
        case .neurology:        return "brain.head.profile"
        case .orthopedics:      return "figure.walk"
        case .psychiatry:       return "brain"
        case .ophthalmology:    return "eye.fill"
        case .gynecology:       return "cross.case.fill"
        case .dentistry:        return "mouth.fill"
        }
    }
}

// MARK: - TimeSlot
struct TimeSlot: Identifiable, Codable, Hashable {
    let id: String
    var date: Date
    var timeString: String  // e.g. "3:00 PM", "3:30 PM"
    var isBooked: Bool
    var isSelected: Bool = false
}

// MARK: - Doctor Model
struct Doctor: Identifiable, Codable, Hashable {
    let id: String
    var user: User
    var specialization: Specialization
    var subSpecialty: String?
    var clinicName: String
    var hospital: String
    var locationArea: String
    var distanceKm: Double
    var yearsOfExperience: Int
    var rating: Double
    var reviewCount: Int
    var consultationFee: Double
    var nextAvailableSlotText: String
    var availableSlots: [TimeSlot]
    var bio: String
    var qualifications: [String]
    var spokenLanguages: [String]
    var isAvailableForVideo: Bool
    
    var formattedFee: String {
        String(format: "Rs. %.0f", consultationFee)
    }
    
    var formattedRating: String {
        String(format: "%.1f", rating)
    }
    
    var formattedDistance: String {
        String(format: "%.1f km away · %@", distanceKm, locationArea)
    }
    
    var displayTitle: String {
        if let sub = subSpecialty, !sub.isEmpty {
            return "\(specialization.rawValue) - \(sub)"
        }
        return specialization.rawValue
    }
}

// MARK: - Mock Doctors (Figma: Colombo Medical Specialists)
extension Doctor {
    static let mockDoctors: [Doctor] = [
        Doctor(
            id: "doc-001",
            user: User(
                id: "user-doc-001",
                fullName: "Dr. Nimal Perera",
                email: "nimal.perera@lankaheart.lk",
                phoneNumber: "+94 11 258 4500",
                role: .doctor,
                createdAt: Date()
            ),
            specialization: .cardiology,
            subSpecialty: "Adult Interventional",
            clinicName: "Lanka Heart Care Clinic",
            hospital: "Lanka Heart Care Clinic (Room 204)",
            locationArea: "Colombo 05",
            distanceKm: 1.8,
            yearsOfExperience: 15,
            rating: 4.9,
            reviewCount: 312,
            consultationFee: 3500,
            nextAvailableSlotText: "Today, 3:00 PM",
            availableSlots: [
                TimeSlot(id: "s-1", date: Date(), timeString: "3:00 PM", isBooked: false),
                TimeSlot(id: "s-2", date: Date(), timeString: "3:30 PM", isBooked: false),
                TimeSlot(id: "s-3", date: Date(), timeString: "4:00 PM", isBooked: false, isSelected: true),
                TimeSlot(id: "s-4", date: Date(), timeString: "4:30 PM", isBooked: true),
                TimeSlot(id: "s-5", date: Date(), timeString: "5:00 PM", isBooked: false),
                TimeSlot(id: "s-6", date: Date(), timeString: "5:30 PM", isBooked: true)
            ],
            bio: "Dr. Nimal Perera is a senior consultant cardiologist specializing in interventional and preventive cardiac care with over 15 years of clinical practice.",
            qualifications: ["MBBS (Colombo)", "MD (Cardiology)", "FRCP (UK)", "FACC"],
            spokenLanguages: ["English", "Sinhala"],
            isAvailableForVideo: true
        ),
        Doctor(
            id: "doc-002",
            user: User(
                id: "user-doc-002",
                fullName: "Dr. Sarah Fernando",
                email: "sarah.fernando@asiri.lk",
                phoneNumber: "+94 11 466 5500",
                role: .doctor,
                createdAt: Date()
            ),
            specialization: .cardiology,
            subSpecialty: "Preventive Cardiology",
            clinicName: "Asiri Central Health Care",
            hospital: "Asiri Central Health Care",
            locationArea: "Colombo 07",
            distanceKm: 3.2,
            yearsOfExperience: 11,
            rating: 4.8,
            reviewCount: 198,
            consultationFee: 3200,
            nextAvailableSlotText: "Tomorrow, 10:00 AM",
            availableSlots: [],
            bio: "Consultant in preventive cardiovascular medicine focusing on hypertension, lipid management, and lifestyle cardiology.",
            qualifications: ["MBBS", "MRCP (London)", "Board Certified in Cardiology"],
            spokenLanguages: ["English", "Sinhala", "Tamil"],
            isAvailableForVideo: true
        ),
        Doctor(
            id: "doc-003",
            user: User(
                id: "user-doc-003",
                fullName: "Dr. Kavindu Silva",
                email: "kavindu.silva@nawaloka.lk",
                phoneNumber: "+94 11 544 4444",
                role: .doctor,
                createdAt: Date()
            ),
            specialization: .cardiology,
            subSpecialty: "Heart Failure Specialist",
            clinicName: "Nawaloka Medicare Center",
            hospital: "Nawaloka Medicare Center",
            locationArea: "Colombo 02",
            distanceKm: 4.5,
            yearsOfExperience: 14,
            rating: 4.7,
            reviewCount: 164,
            consultationFee: 3000,
            nextAvailableSlotText: "Tomorrow, 2:30 PM",
            availableSlots: [],
            bio: "Expert in advanced heart failure therapies, echocardiography, and non-invasive cardiovascular diagnostics.",
            qualifications: ["MBBS", "MD", "Fellow of Heart Failure Society of America"],
            spokenLanguages: ["English", "Sinhala"],
            isAvailableForVideo: false
        ),
        Doctor(
            id: "doc-004",
            user: User(
                id: "user-doc-004",
                fullName: "Dr. Anoma Wijesinghe",
                email: "anoma.wijesinghe@durdans.lk",
                phoneNumber: "+94 11 214 0000",
                role: .doctor,
                createdAt: Date()
            ),
            specialization: .cardiology,
            subSpecialty: "Pediatric Cardiology",
            clinicName: "Durdans Hospital Heart Centre",
            hospital: "Durdans Hospital Heart Centre",
            locationArea: "Colombo 03",
            distanceKm: 5.1,
            yearsOfExperience: 18,
            rating: 4.95,
            reviewCount: 420,
            consultationFee: 4000,
            nextAvailableSlotText: "Friday, 9:00 AM",
            availableSlots: [],
            bio: "Leading pediatric cardiologist with expertise in congenital heart disease and pediatric cardiac interventions.",
            qualifications: ["MBBS", "MD (Paediatrics)", "FRCPCH (UK)"],
            spokenLanguages: ["English", "Sinhala"],
            isAvailableForVideo: true
        )
    ]
}
