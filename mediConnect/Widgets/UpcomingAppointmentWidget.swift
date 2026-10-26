// UpcomingAppointmentWidget.swift
// MediConnect — Widgets
//
// WidgetKit Upcoming Appointment Home Screen Widget (PRD Feature 02):
// - Supports systemSmall and systemMedium widget families
// - Displays attending specialist, consultation time, clinic location, and assigned queue token
// - Supports deep-linking via .widgetURL to seamlessly open the appointment details screen
// - Provides dual compatibility for native iOS WidgetKit target and macOS CLI typecheck

import SwiftUI
import WidgetKit

// MARK: - Timeline Entry
public struct AppointmentWidgetEntry: TimelineEntry {
    public let date: Date
    public let appointmentId: String
    public let doctorName: String
    public let specialization: String
    public let clinicName: String
    public let roomNumber: String
    public let formattedDate: String
    public let formattedTime: String
    public let queueToken: String
    public let isUpcoming: Bool
    
    public init(
        date: Date = Date(),
        appointmentId: String = "appt-001",
        doctorName: String = "Dr. Nimal Perera",
        specialization: String = "Cardiologist",
        clinicName: String = "Lanka Heart Care Clinic",
        roomNumber: String = "Room 204",
        formattedDate: String = "Today",
        formattedTime: String = "10:30 AM",
        queueToken: String = "A-08",
        isUpcoming: Bool = true
    ) {
        self.date = date
        self.appointmentId = appointmentId
        self.doctorName = doctorName
        self.specialization = specialization
        self.clinicName = clinicName
        self.roomNumber = roomNumber
        self.formattedDate = formattedDate
        self.formattedTime = formattedTime
        self.queueToken = queueToken
        self.isUpcoming = isUpcoming
    }
    
    public static let placeholder = AppointmentWidgetEntry()
    public static let empty = AppointmentWidgetEntry(isUpcoming: false)
}

// MARK: - Timeline Provider
public struct UpcomingAppointmentProvider: TimelineProvider {
    
    public typealias Entry = AppointmentWidgetEntry
    
    public init() {}
    
    public func placeholder(in context: Context) -> AppointmentWidgetEntry {
        AppointmentWidgetEntry.placeholder
    }
    
    public func getSnapshot(in context: Context, completion: @escaping (AppointmentWidgetEntry) -> Void) {
        completion(AppointmentWidgetEntry.placeholder)
    }
    
    public func getTimeline(in context: Context, completion: @escaping (Timeline<AppointmentWidgetEntry>) -> Void) {
        let entry = AppointmentWidgetEntry()
        // Refresh every 15 minutes or when queue changes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

// MARK: - Widget View
public struct UpcomingAppointmentEntryView: View {
    
    public var entry: AppointmentWidgetEntry
    
    #if os(iOS)
    @Environment(\.widgetFamily) var family
    #endif
    
    public init(entry: AppointmentWidgetEntry) {
        self.entry = entry
    }
    
    public var body: some View {
        Group {
            #if os(iOS)
            switch family {
            case .systemSmall:
                smallWidgetView
            default:
                mediumWidgetView
            }
            #else
            mediumWidgetView
            #endif
        }
        .widgetURL(URL(string: "mediconnect://appointment/\(entry.appointmentId)"))
    }
    
    // MARK: - Small Widget Family (2x2)
    private var smallWidgetView: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // Header: Specialty Chip & Status Dot
            HStack {
                Text(entry.specialization)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(Color.mcTeal)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.mcTealLight)
                    .clipShape(Capsule())
                
                Spacer()
                
                Circle()
                    .fill(Color.mcStatusGreen)
                    .frame(width: 6, height: 6)
            }
            
            // Doctor Name
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.doctorName)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color.mcTextPrimary)
                    .lineLimit(2)
                
                Text(entry.clinicName)
                    .font(.system(size: 10))
                    .foregroundStyle(Color.mcTextSecondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Time & Token Footer
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text(entry.formattedDate)
                        .font(.system(size: 8, weight: .semibold))
                        .foregroundStyle(Color.mcTextLabel)
                    Text(entry.formattedTime)
                        .font(.system(size: 12, weight: .heavy))
                        .foregroundStyle(Color.mcTeal)
                }
                
                Spacer()
                
                // Token Badge
                Text(entry.queueToken)
                    .font(.system(size: 11, weight: .heavy))
                    .foregroundStyle(Color.mcTeal)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.mcTealLight)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding(14)
        .background(Color.white)
    }
    
    // MARK: - Medium Widget Family (4x2)
    private var mediumWidgetView: some View {
        HStack(spacing: 14) {
            
            // Left Column: Doctor Info & Clinic
            VStack(alignment: .leading, spacing: 6) {
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.mcStatusGreen)
                        .frame(width: 6, height: 6)
                    
                    Text("UPCOMING APPOINTMENT")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(Color.mcTextLabel)
                        .tracking(0.5)
                }
                
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.mcTealLight)
                            .frame(width: 38, height: 38)
                        
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 34))
                            .foregroundStyle(Color.mcTeal)
                    }
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text(entry.doctorName)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(Color.mcTextPrimary)
                        
                        Text(entry.specialization)
                            .font(.system(size: 11))
                            .foregroundStyle(Color.mcTextSecondary)
                    }
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(Color.mcTeal)
                    
                    Text("\(entry.clinicName) · \(entry.roomNumber)")
                        .font(.system(size: 10))
                        .foregroundStyle(Color.mcTextSecondary)
                        .lineLimit(1)
                }
                .padding(.top, 2)
            }
            
            Divider()
                .background(Color.mcBorderLight)
            
            // Right Column: Date, Time & Queue Number
            VStack(spacing: 8) {
                
                VStack(spacing: 2) {
                    Text(entry.formattedDate)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.mcStatusGreen)
                    
                    Text(entry.formattedTime)
                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color.mcTeal)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.mcTealLight.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                // Queue Token Pill
                HStack(spacing: 4) {
                    Text("Token")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundStyle(Color.mcTextSecondary)
                    Text(entry.queueToken)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.mcTeal)
                }
            }
            .frame(width: 90)
        }
        .padding(14)
        .background(Color.white)
    }
}

// MARK: - Widget Configuration
public struct UpcomingAppointmentWidget: Widget {
    
    public let kind: String = "UpcomingAppointmentWidget"
    
    public init() {}
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: UpcomingAppointmentProvider()) { entry in
            UpcomingAppointmentEntryView(entry: entry)
        }
        .configurationDisplayName("Upcoming Appointment")
        .description("Keep track of your next consultation schedule, clinic room, and assigned queue token at a glance.")
        #if os(iOS)
        .supportedFamilies([.systemSmall, .systemMedium])
        #endif
    }
}

#if DEBUG
struct UpcomingAppointmentWidget_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingAppointmentEntryView(entry: AppointmentWidgetEntry())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
#endif
