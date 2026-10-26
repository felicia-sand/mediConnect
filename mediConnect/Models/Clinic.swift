// Clinic.swift
// MediConnect — Models
//
// Clinic and Hospital location model matching Figma specifications:
// - Coordinates for MapKit and Core Location geofencing
// - Distance calculation from patient location
// - Hospital department & contact details

import Foundation

// MARK: - Clinic Model
struct Clinic: Identifiable, Codable, Hashable {
    let id: String
    var name: String
    var subtitle: String?
    var address: String
    var city: String
    var postalCode: String?
    var latitude: Double
    var longitude: Double
    var distanceKm: Double
    var driveTimeMinutes: Int
    var phone: String
    var openingHours: String
    var specialties: [String]
    var isEmergencyCareAvailable: Bool
    
    // Formatted presentation
    var formattedDistance: String {
        String(format: "%.1f km", distanceKm)
    }
    
    var formattedDriveTime: String {
        "~\(driveTimeMinutes) mins drive"
    }
}

// MARK: - Mock Data (Figma: Colombo Healthcare Hubs)
extension Clinic {
    static let mockClinics: [Clinic] = [
        Clinic(
            id: "clinic-001",
            name: "Lanka Heart Care Clinic",
            subtitle: "Cardiology & Diagnostic Specialist Wing",
            address: "No. 45, Galle Road, Suite 2B",
            city: "Colombo 05",
            postalCode: "00500",
            latitude: 6.8920,
            longitude: 79.8565,
            distanceKm: 1.8,
            driveTimeMinutes: 7,
            phone: "+94 11 258 4500",
            openingHours: "Open · Closes 7:30 PM",
            specialties: ["Cardiology", "Diagnostics", "Preventive Care"],
            isEmergencyCareAvailable: true
        ),
        Clinic(
            id: "clinic-002",
            name: "Asiri Central Health Care",
            subtitle: "Multispecialty Outpatient Center",
            address: "114 Norris Canal Rd",
            city: "Colombo 10",
            postalCode: "01000",
            latitude: 6.9240,
            longitude: 79.8680,
            distanceKm: 3.2,
            driveTimeMinutes: 12,
            phone: "+94 11 466 5500",
            openingHours: "Open 24 Hours",
            specialties: ["Cardiology", "General Practice", "Neurology"],
            isEmergencyCareAvailable: true
        ),
        Clinic(
            id: "clinic-003",
            name: "Nawaloka Medicare Center",
            subtitle: "General Healthcare & Specialist Clinics",
            address: "Deshamanya H.K. Dharmadasa Mw",
            city: "Colombo 02",
            postalCode: "00200",
            latitude: 6.9280,
            longitude: 79.8520,
            distanceKm: 4.5,
            driveTimeMinutes: 16,
            phone: "+94 11 544 4444",
            openingHours: "Open · Closes 9:00 PM",
            specialties: ["General Practice", "Pediatrics", "Cardiology"],
            isEmergencyCareAvailable: false
        ),
        Clinic(
            id: "clinic-004",
            name: "Durdans Hospital Heart Centre",
            subtitle: "Specialized Cardiac & Critical Care Unit",
            address: "3 Alfred Place",
            city: "Colombo 03",
            postalCode: "00300",
            latitude: 6.9010,
            longitude: 79.8530,
            distanceKm: 5.1,
            driveTimeMinutes: 18,
            phone: "+94 11 214 0000",
            openingHours: "Open 24 Hours",
            specialties: ["Cardiology", "Pediatric Cardiology", "Orthopedic"],
            isEmergencyCareAvailable: true
        )
    ]
}
