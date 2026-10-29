// AppointmentDetailView.swift
// MediConnect — Features/Appointments/Views
//
// Appointment Detail Screen matching Figma specifications (Page 6):
// - Attending Specialist Card with verified care team badge
// - Direct clinic contact buttons (Message / Call)
// - Clinic Location Map thumbnail with "Get Directions"
// - Queue Check-in Token card (A-08) and "View Queue" link
// - Reschedule & Cancellation terms with confirmation alert

import SwiftUI
import MapKit

struct AppointmentDetailView: View {
    
    @State var appointment: Appointment
    @State private var showCancelAlert: Bool = false
    @State private var showRescheduleSheet: Bool = false
    @State private var rescheduleDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State private var rescheduleSlotTime: String = "3:30 PM"
    @State private var rescheduleReason: String = ""
    @State private var showRescheduleSuccessBanner: Bool = false
    @State private var showDirectionsSheet: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    let availableRescheduleSlots = ["09:30 AM", "10:30 AM", "11:30 AM", "03:00 PM", "03:30 PM", "04:30 PM", "05:00 PM"]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                
                // Reschedule Success Banner
                if showRescheduleSuccessBanner {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.mcStatusGreen)
                        Text("Appointment rescheduled successfully to \(appointment.formattedDate) at \(rescheduleSlotTime)!")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.mcStatusGreen)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color.mcStatusGreenBg)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.top, 4)
                }
                
                // MARK: - 1. Attending Specialist Card
                attendingSpecialistCard
                    .padding(.top, showRescheduleSuccessBanner ? 0 : 4)
                
                // MARK: - 2. Clinic Location & Directions Card
                clinicLocationCard
                
                // MARK: - 3. Schedule Badge Card
                scheduleCard
                
                // MARK: - 4. Queue Check-In Status Card
                if appointment.isCheckedIn {
                    NavigationLink {
                        LiveQueueView(viewModel: QueueViewModel(appointment: appointment))
                    } label: {
                        queueStatusCard
                    }
                    .buttonStyle(.plain)
                }
                
                // MARK: - 5. Reschedule Action
                rescheduleButton
                
                // MARK: - 6. Cancellation Terms & Cancel Button
                if appointment.status != .cancelled {
                    cancellationSection
                } else {
                    cancelledNoticeBanner
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .background(Color.mcAppBg.ignoresSafeArea())
        .navigationTitle("Appointment Details")
        .inlineNavigationBarTitle()
        .alert("Cancel Appointment?", isPresented: $showCancelAlert) {
            Button("Keep Appointment", role: .cancel) {}
            Button("Cancel Appointment", role: .destructive) {
                appointment.status = .cancelled
                NotificationService.shared.cancelAppointmentReminders(for: appointment.id)
            }
        } message: {
            Text("Are you sure you want to cancel this appointment? Cancelling immediately opens the slot for emergency patients.")
        }
        .sheet(isPresented: $showRescheduleSheet) {
            rescheduleSheetView
        }
        .sheet(isPresented: $showDirectionsSheet) {
            directionsSheetView
        }
    }
    
    // MARK: - Subviews
    
    // 1. Attending Specialist Card
    private var attendingSpecialistCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            // Header: Next Appointment Tag
            HStack {
                Text("ATTENDING SPECIALIST")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.mcTextLabel)
                    .tracking(0.5)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.mcStatusGreen)
                        .frame(width: 6, height: 6)
                    Text("Today")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.mcStatusGreen)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.mcStatusGreenBg)
                .clipShape(Capsule())
            }
            
            // Doctor Info
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.mcTealLight)
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(Color.mcTeal)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 4) {
                        Text(appointment.doctor?.user.fullName ?? "Dr. Nimal Perera")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.mcTextPrimary)
                        
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.mcStatusGreen)
                    }
                    
                    Text(appointment.doctor?.displayTitle ?? "Cardiologist - Adult Interventional")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.mcTextSecondary)
                    
                    Text("MBBS, MD, FRCP (UK), FACC")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.mcTextSecondary.opacity(0.8))
                }
                
                Spacer()
            }
            
            // Communication Quick Actions
            HStack(spacing: 10) {
                Button {
                    // Message Clinic action
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "message.fill")
                            .font(.system(size: 12))
                        Text("Message Clinic")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 38)
                    .foregroundStyle(Color.mcTeal)
                    .background(Color.mcTealLight.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
                
                Button {
                    // Direct Line phone action
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 12))
                        Text("Direct Line")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 38)
                    .foregroundStyle(Color.mcTeal)
                    .background(Color.mcTealLight.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.mcBorderLight, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.02), radius: 6, x: 0, y: 2)
    }
    
    // 2. Clinic Location & Directions Card
    private var clinicLocationCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Map Distance Header
            HStack(spacing: 6) {
                Image(systemName: "location.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.mcTeal)
                
                Text("1.8 km away · ~7 mins drive")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.mcTextPrimary)
            }
            
            // Clinic Address Details
            VStack(alignment: .leading, spacing: 2) {
                Text(appointment.clinicName)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Color.mcTextPrimary)
                
                Text(appointment.clinicAddress)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.mcTextSecondary)
                
                Text("Cardiology Wing · Suite 2B, 2nd Floor (Room 204)")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.mcTextSecondary.opacity(0.8))
            }
            
            // Get Directions Button
            Button {
                showDirectionsSheet = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                        .font(.system(size: 14))
                    Text("Get Directions")
                        .font(.system(size: 14, weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .foregroundStyle(.white)
                .background(Color.mcTeal)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.mcBorderLight, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.02), radius: 6, x: 0, y: 2)
    }
    
    // 3. Schedule Card
    private var scheduleCard: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.mcTealLight)
                    .frame(width: 46, height: 46)
                
                Image(systemName: "calendar")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.mcTeal)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(appointment.formattedDate)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.mcTextPrimary)
                
                Text("\(appointment.formattedTime) · In-person (~20 mins)")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.mcTextSecondary)
            }
            
            Spacer()
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.mcBorderLight, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 1)
    }
    
    // 4. Queue Check-In Status Card (Figma Page 6)
    private var queueStatusCard: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.mcStatusGreenBg)
                    .frame(width: 44, height: 44)
                
                Image(systemName: "person.badge.shield.checkmark.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.mcStatusGreen)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text("You're Checked In")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.mcTextPrimary)
                
                let queue = appointment.queueNumber ?? "A-08"
                Text("Your queue number is \(queue). \(appointment.peopleAheadCount) person is ahead of you.")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.mcTextSecondary)
            }
            
            Spacer()
            
            HStack(spacing: 2) {
                Text("View Queue")
                    .font(.system(size: 12, weight: .bold))
                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .bold))
            }
            .foregroundStyle(Color.mcTeal)
        }
        .padding(14)
        .background(Color.mcTealLight.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.mcTealBorder, lineWidth: 1)
        )
    }
    
    // 5. Reschedule Action Button
    private var rescheduleButton: some View {
        Button {
            showRescheduleSheet = true
        } label: {
            VStack(spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Reschedule Appointment")
                        .font(.system(size: 14, weight: .bold))
                }
                .foregroundStyle(Color.mcTeal)
                
                Text("Change date or time slot without fee up to 2 hours prior")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.mcTextSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.mcTealBorder, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Reschedule Modal Sheet
    private var rescheduleSheetView: some View {
        NavigationStack {
            Form {
                Section("Select New Date") {
                    DatePicker(
                        "Consultation Date",
                        selection: $rescheduleDate,
                        in: Date()...,
                        displayedComponents: .date
                    )
                    .tint(Color.mcTeal)
                }
                
                Section("Available Time Slots") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(availableRescheduleSlots, id: \.self) { slot in
                                let isSelected = rescheduleSlotTime == slot
                                Button {
                                    rescheduleSlotTime = slot
                                } label: {
                                    Text(slot)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(isSelected ? .white : Color.mcTextPrimary)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(isSelected ? Color.mcTeal : Color.mcInputBg)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(isSelected ? Color.mcTeal : Color.mcBorderLight, lineWidth: 1)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section("Reason for Rescheduling (Optional)") {
                    TextField("e.g. Schedule clash, work emergency...", text: $rescheduleReason)
                        .font(.system(size: 14))
                }
                
                Section {
                    Button {
                        // Confirm Reschedule
                        appointment.scheduledDate = rescheduleDate
                        appointment.notes = "Rescheduled to \(rescheduleSlotTime) · Reason: \(rescheduleReason.isEmpty ? "Patient request" : rescheduleReason)"
                        
                        // Reschedule Notification Reminders
                        NotificationService.shared.cancelAppointmentReminders(for: appointment.id)
                        NotificationService.shared.scheduleAppointmentReminders(for: appointment)
                        
                        showRescheduleSheet = false
                        withAnimation {
                            showRescheduleSuccessBanner = true
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Confirm Reschedule")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        .frame(height: 44)
                        .background(Color.mcTeal)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("Reschedule Appointment")
            .inlineNavigationBarTitle()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showRescheduleSheet = false
                    }
                }
            }
        }
    }
    
    // MARK: - Directions Sheet View
    private var directionsSheetView: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Header Map Card
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundStyle(Color.mcTeal)
                        Text(appointment.clinicName)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.mcTextPrimary)
                    }
                    
                    Text(appointment.clinicAddress)
                        .font(.system(size: 13))
                        .foregroundStyle(Color.mcTextSecondary)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "car.fill")
                            .font(.system(size: 12))
                        Text("1.8 km · ~7 mins drive via Galle Road")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundStyle(Color.mcTeal)
                    .padding(.top, 4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(Color.mcTealLight.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                
                // Driving Guidance Steps
                VStack(alignment: .leading, spacing: 14) {
                    Text("ROUTE GUIDANCE")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.mcTextLabel)
                    
                    stepRow(stepNumber: "1", instruction: "Head south on Galle Road (A2) toward Colombo 05", distance: "1.1 km")
                    stepRow(stepNumber: "2", instruction: "Turn left onto Havelock Road at the intersection", distance: "500 m")
                    stepRow(stepNumber: "3", instruction: "Arrive at \(appointment.clinicName) on your left (Room 204)", distance: "200 m")
                }
                .padding(16)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.mcBorderLight, lineWidth: 1)
                )
                
                Spacer()
                
                // Open in Apple Maps Button
                Button {
                    openNativeMaps()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                        Text("Open Navigation in Apple Maps")
                            .font(.system(size: 15, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundStyle(.white)
                    .background(Color.mcTeal)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
            .padding(20)
            .navigationTitle("Directions & Route")
            .inlineNavigationBarTitle()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        showDirectionsSheet = false
                    }
                }
            }
        }
    }
    
    private func stepRow(stepNumber: String, instruction: String, distance: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(stepNumber)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(Color.mcTeal)
                .frame(width: 24, height: 24)
                .background(Color.mcTealLight)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(instruction)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.mcTextPrimary)
                Text(distance)
                    .font(.system(size: 11))
                    .foregroundStyle(Color.mcTextSecondary)
            }
            Spacer()
        }
    }
    
    private func openNativeMaps() {
        let coordinate = CLLocationCoordinate2D(latitude: 6.8920, longitude: 79.8565)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = appointment.clinicName
        #if os(iOS)
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
        #endif
    }
    
    // 6. Cancellation Terms Card & Cancel Button
    private var cancellationSection: some View {
        VStack(spacing: 12) {
            
            // Terms Card
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.mcStatusOrange)
                    Text("Cancellation Terms")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color.mcTextPrimary)
                }
                
                Text("Free cancellation is eligible until 2 hours prior to the scheduled time. Cancelling immediately opens the slot for emergency patients.")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.mcTextSecondary)
                    .lineSpacing(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color.mcStatusOrange.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.mcStatusOrange.opacity(0.2), lineWidth: 1)
            )
            
            // Cancel Danger Button
            Button {
                showCancelAlert = true
            } label: {
                Text("Cancel Appointment")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(Color.mcStatusRed)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
        }
    }
    
    // Cancelled Banner
    private var cancelledNoticeBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(Color.mcStatusRed)
            Text("This appointment has been cancelled.")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.mcStatusRed)
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .background(Color.mcStatusRed.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#if DEBUG
struct AppointmentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AppointmentDetailView(appointment: Appointment.mockUpcoming)
        }
    }
}
#endif
