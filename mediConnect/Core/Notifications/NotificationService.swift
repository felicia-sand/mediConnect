// NotificationService.swift
// MediConnect — Core/Notifications
//
// UserNotifications Management Service (PRD Feature 02 & Advanced SDK Feature 02):
// - Manages notification permissions (Alerts, Sounds, Badges)
// - Schedules automated 24-hour and 2-hour appointment reminders
// - Dispatches geofence arrival check-in notifications
// - Triggers high-priority audible alerts when patient token is called by the doctor
// - Handles in-app foreground notification delivery

import Foundation
import UserNotifications
import Combine

@MainActor
final class NotificationService: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    public static let shared = NotificationService()
    
    // MARK: - Published Properties
    @Published var isAuthorized: Bool = false
    @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined
    @Published var pushNotificationsEnabled: Bool = true
    @Published var smsRemindersEnabled: Bool = true
    @Published var queueChimeAlertsEnabled: Bool = true
    @Published var proximityAlertsEnabled: Bool = true
    
    // MARK: - Init
    override init() {
        super.init()
        #if !os(macOS) || !targetEnvironment(simulator)
        UNUserNotificationCenter.current().delegate = self
        #endif
        checkAuthorizationStatus()
    }
    
    // MARK: - Authorization
    func requestAuthorization() {
        #if canImport(UserNotifications)
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            Task { @MainActor in
                self?.isAuthorized = granted
                self?.checkAuthorizationStatus()
            }
        }
        #endif
    }
    
    func checkAuthorizationStatus() {
        #if canImport(UserNotifications)
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { [weak self] settings in
            Task { @MainActor in
                self?.authorizationStatus = settings.authorizationStatus
                self?.isAuthorized = (settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional)
            }
        }
        #endif
    }
    
    // MARK: - Appointment Reminders
    /// Schedules both 24-hour and 2-hour local reminders for an upcoming appointment
    func scheduleAppointmentReminders(for appointment: Appointment) {
        guard isAuthorized else { return }
        
        let center = UNUserNotificationCenter.current()
        let doctorName = appointment.doctor?.user.fullName ?? "your doctor"
        let clinic = appointment.clinicName
        
        // 1. 24-Hour Reminder
        let reminder24hDate = appointment.scheduledDate.addingTimeInterval(-24 * 3600)
        if reminder24hDate > Date() {
            let content24h = UNMutableNotificationContent()
            content24h.title = "Upcoming Appointment Tomorrow 🩺"
            content24h.body = "You have an appointment with \(doctorName) at \(clinic) tomorrow at \(appointment.formattedTime)."
            content24h.sound = .default
            content24h.userInfo = ["appointmentId": appointment.id]
            
            let trigger24h = UNTimeIntervalNotificationTrigger(
                timeInterval: reminder24hDate.timeIntervalSinceNow,
                repeats: false
            )
            let request24h = UNNotificationRequest(
                identifier: "\(appointment.id)_24h",
                content: content24h,
                trigger: trigger24h
            )
            center.add(request24h)
        }
        
        // 2. 2-Hour Reminder
        let reminder2hDate = appointment.scheduledDate.addingTimeInterval(-2 * 3600)
        if reminder2hDate > Date() {
            let content2h = UNMutableNotificationContent()
            content2h.title = "Appointment in 2 Hours ⏰"
            content2h.body = "Reminder: Your appointment with \(doctorName) begins at \(appointment.formattedTime). Free cancellation ends now."
            content2h.sound = .default
            content2h.userInfo = ["appointmentId": appointment.id]
            
            let trigger2h = UNTimeIntervalNotificationTrigger(
                timeInterval: reminder2hDate.timeIntervalSinceNow,
                repeats: false
            )
            let request2h = UNNotificationRequest(
                identifier: "\(appointment.id)_2h",
                content: content2h,
                trigger: trigger2h
            )
            center.add(request2h)
        }
    }
    
    // MARK: - Geofence Arrival Check-In Notification
    func dispatchArrivalNotification(for clinic: Clinic, queueToken: String = "A-08") {
        guard proximityAlertsEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Arrived at \(clinic.name) 📍"
        content.body = "Automated check-in complete! Your queue number is \(queueToken). Please proceed to Waiting Lounge B."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "arrival_\(clinic.id)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Queue Token Summon Notification
    func dispatchQueueSummonNotification(doctorName: String, roomNumber: String, token: String = "A-08") {
        guard queueChimeAlertsEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "It's Your Turn! Token \(token) 🩺"
        content.body = "\(doctorName) is ready for you. Please proceed immediately to \(roomNumber)."
        content.sound = .defaultCritical
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "summon_\(token)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Cancel Reminders
    func cancelAppointmentReminders(for appointmentId: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [
            "\(appointmentId)_24h",
            "\(appointmentId)_2h"
        ])
    }
    
    // MARK: - Foreground Notification Delegate
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        #if os(iOS)
        completionHandler([.banner, .sound, .badge])
        #else
        completionHandler([.sound, .badge])
        #endif
    }
}
