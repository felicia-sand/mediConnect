// AppointmentsListView.swift
// MediConnect — Features/Appointments/Views
//
// Appointments tab view matching Figma specifications:
// - "Upcoming" vs "Past" segmented toggle
// - Active appointment cards with queue status and action buttons

import SwiftUI

struct AppointmentsListView: View {
    
    @State private var selectedSegment: Int = 0 // 0: Upcoming, 1: Past
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                // Segmented Control
                Picker("Appointments", selection: $selectedSegment) {
                    Text("Upcoming (1)").tag(0)
                    Text("Medical History (1)").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // Appointment List
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        if selectedSegment == 0 {
                            NavigationLink {
                                AppointmentDetailView(appointment: Appointment.mockUpcoming)
                            } label: {
                                appointmentCard(Appointment.mockUpcoming)
                            }
                            .buttonStyle(.plain)
                        } else {
                            ForEach(Appointment.mockHistory.filter { $0.status == .completed }) { appt in
                                NavigationLink {
                                    AppointmentDetailView(appointment: appt)
                                } label: {
                                    appointmentCard(appt)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Appointments")
            .inlineNavigationBarTitle()
            .background(Color.mcAppBg.ignoresSafeArea())
        }
    }
    
    @ViewBuilder
    private func appointmentCard(_ appointment: Appointment) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            
            // Header: Status Pill
            HStack {
                HStack(spacing: 5) {
                    Circle()
                        .fill(appointment.status == .confirmed ? Color.mcStatusGreen : Color.mcTextSecondary)
                        .frame(width: 7, height: 7)
                    
                    Text(appointment.status.displayName)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(appointment.status == .confirmed ? Color.mcStatusGreen : Color.mcTextSecondary)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(appointment.status == .confirmed ? Color.mcStatusGreenBg : Color.mcBorderLight)
                .clipShape(Capsule())
                
                Spacer()
                
                Text(appointment.formattedDate)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.mcTextSecondary)
            }
            
            // Doctor Details
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.mcTealLight)
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 42))
                        .foregroundStyle(Color.mcTeal)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(appointment.doctor?.user.fullName ?? "Dr. Nimal Perera")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.mcTextPrimary)
                    
                    Text(appointment.doctor?.displayTitle ?? "Cardiologist")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.mcTextSecondary)
                    
                    Text(appointment.clinicName)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.mcTextSecondary)
                }
                
                Spacer()
            }
            
            // Queue Badge if checked in
            if appointment.isCheckedIn, let queue = appointment.queueNumber {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.mcStatusGreen)
                    
                    Text("Checked In · Queue No: \(queue)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.mcTextPrimary)
                    
                    Spacer()
                    
                    Text("\(appointment.peopleAheadCount) ahead")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.mcTeal)
                }
                .padding(10)
                .background(Color.mcTealLight.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            // Clinical Summary if completed (Medical History view)
            if appointment.status == .completed {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "cross.case.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(Color.mcTeal)
                        Text("Diagnosis: Mild Essential Hypertension (Stable)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.mcTextPrimary)
                    }
                    
                    HStack(spacing: 6) {
                        Image(systemName: "pills.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(Color.mcStatusGreen)
                        Text("Rx: Amlodipine 5mg (Daily) · Atorvastatin 20mg (Night)")
                            .font(.system(size: 11))
                            .foregroundStyle(Color.mcTextSecondary)
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.mcTealLight.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            // Schedule & Time Info
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.mcTeal)
                    Text(appointment.formattedTime)
                        .font(.system(size: 13, weight: .semibold))
                }
                
                Spacer()
                
                Text(appointment.type.displayName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.mcTextSecondary)
            }
            .foregroundStyle(Color.mcTextPrimary)
        }
        .padding(16)
        .background(Color.mcCardBg)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.mcBorderLight, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
    }
}

#if DEBUG
struct AppointmentsListView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentsListView()
            .environmentObject(AuthViewModel())
    }
}
#endif
