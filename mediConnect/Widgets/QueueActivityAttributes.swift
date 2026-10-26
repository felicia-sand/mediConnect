// QueueActivityAttributes.swift
// MediConnect — Widgets / ActivityKit
//
// ActivityKit Live Activity Attributes (PRD Advanced SDK Feature 03):
// - Enables real-time queue position streaming to the Lock Screen and Dynamic Island
// - Updates dynamically as the clinic queue advances without opening the app
// - Dual compilation support: Full ActivityAttributes conformance on iOS, resilient stub on macOS CLI

import Foundation

#if os(iOS) && canImport(ActivityKit)
import ActivityKit

public struct QueueActivityAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        public var nowServingNumber: String
        public var peopleAheadCount: Int
        public var estimatedWaitMinutes: Int
        public var statusMessage: String
        public var isCurrentUserTurn: Bool
        public var lastUpdated: Date
        
        public init(
            nowServingNumber: String,
            peopleAheadCount: Int,
            estimatedWaitMinutes: Int,
            statusMessage: String,
            isCurrentUserTurn: Bool = false,
            lastUpdated: Date = Date()
        ) {
            self.nowServingNumber = nowServingNumber
            self.peopleAheadCount = peopleAheadCount
            self.estimatedWaitMinutes = estimatedWaitMinutes
            self.statusMessage = statusMessage
            self.isCurrentUserTurn = isCurrentUserTurn
            self.lastUpdated = lastUpdated
        }
    }
    
    // Fixed attributes per appointment
    public var appointmentId: String
    public var doctorName: String
    public var doctorSpecialty: String
    public var clinicName: String
    public var roomNumber: String
    public var patientQueueNumber: String
    
    public init(
        appointmentId: String,
        doctorName: String,
        doctorSpecialty: String,
        clinicName: String,
        roomNumber: String,
        patientQueueNumber: String
    ) {
        self.appointmentId = appointmentId
        self.doctorName = doctorName
        self.doctorSpecialty = doctorSpecialty
        self.clinicName = clinicName
        self.roomNumber = roomNumber
        self.patientQueueNumber = patientQueueNumber
    }
}
#else
// Standalone structure for macOS CLI typecheck & previews
struct QueueActivityAttributes {
    
    struct ContentState: Codable, Hashable {
        var nowServingNumber: String
        var peopleAheadCount: Int
        var estimatedWaitMinutes: Int
        var statusMessage: String
        var isCurrentUserTurn: Bool
        var lastUpdated: Date
        
        init(
            nowServingNumber: String,
            peopleAheadCount: Int,
            estimatedWaitMinutes: Int,
            statusMessage: String,
            isCurrentUserTurn: Bool = false,
            lastUpdated: Date = Date()
        ) {
            self.nowServingNumber = nowServingNumber
            self.peopleAheadCount = peopleAheadCount
            self.estimatedWaitMinutes = estimatedWaitMinutes
            self.statusMessage = statusMessage
            self.isCurrentUserTurn = isCurrentUserTurn
            self.lastUpdated = lastUpdated
        }
    }
    
    var appointmentId: String
    var doctorName: String
    var doctorSpecialty: String
    var clinicName: String
    var roomNumber: String
    var patientQueueNumber: String
    
    init(
        appointmentId: String,
        doctorName: String,
        doctorSpecialty: String,
        clinicName: String,
        roomNumber: String,
        patientQueueNumber: String
    ) {
        self.appointmentId = appointmentId
        self.doctorName = doctorName
        self.doctorSpecialty = doctorSpecialty
        self.clinicName = clinicName
        self.roomNumber = roomNumber
        self.patientQueueNumber = patientQueueNumber
    }
}
#endif
