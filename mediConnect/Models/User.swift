// User.swift
// MediConnect — Models
//
// Created by Felicia on 25/10/2026.

import Foundation

// MARK: - User Role
enum UserRole: String, Codable {
    case patient = "patient"
    case doctor  = "doctor"
    case admin   = "admin"
}

// MARK: - User Model
struct User: Identifiable, Codable, Hashable {
    let id: String
    var fullName: String
    var email: String
    var phoneNumber: String?
    var profileImageURL: String?
    var role: UserRole
    var dateOfBirth: Date?
    var createdAt: Date
    
    // Computed
    var firstName: String {
        fullName.components(separatedBy: " ").first ?? fullName
    }
    
    var initials: String {
        let components = fullName.components(separatedBy: " ")
        return components.compactMap { $0.first }.map { String($0) }.joined().uppercased()
    }
}

// MARK: - Mock Data
extension User {
    static let mockPatient = User(
        id: "user-001",
        fullName: "Sarah Johnson",
        email: "sarah.johnson@email.com",
        phoneNumber: "+1 555-0101",
        role: .patient,
        dateOfBirth: Calendar.current.date(from: DateComponents(year: 1992, month: 6, day: 15)),
        createdAt: Date()
    )
    
    static let mockDoctor = User(
        id: "user-002",
        fullName: "Dr. Michael Chen",
        email: "dr.chen@mediconnect.com",
        phoneNumber: "+1 555-0202",
        role: .doctor,
        createdAt: Date()
    )
}
