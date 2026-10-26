// CheckInSuccessView.swift
// MediConnect — Features/Queue/Views
//
// Geofence & Check-In Success Screen matching Figma specifications (Page 7):
// - Automated arrival confirmation header
// - Assigned Queue Token Card (A-08 Confirmed · In Line)
// - Attending Specialist & Room 204 summary
// - Waiting Lounge B guidance & clinic amenities
// - Navigation handoff to Live Queue tracking

import SwiftUI

struct CheckInSuccessView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: QueueViewModel
    @State private var navigateToLiveQueue: Bool = false
    
    init(appointment: Appointment = Appointment.mockUpcoming) {
        _viewModel = StateObject(wrappedValue: QueueViewModel(appointment: appointment))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    // MARK: - 1. Animated Check-In Hero Badge
                    heroArrivalSection
                        .padding(.top, 10)
                    
                    // MARK: - 2. Queue Number Card (A-08)
                    queueNumberCard
                    
                    // MARK: - 3. Attending Specialist Banner
                    attendingDoctorBanner
                    
                    // MARK: - 4. Lounge & Amenities Guidance
                    loungeGuidanceCard
                    
                    // MARK: - 5. Live Queue CTA Button
                    actionButtonsSection
                        .padding(.top, 4)
                        .padding(.bottom, 24)
                }
                .padding(.horizontal, 20)
            }
            .background(Color.mcAppBg.ignoresSafeArea())
            .navigationTitle("Check-In")
            .inlineNavigationBarTitle()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(Color.mcTextSecondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationDestination(isPresented: $navigateToLiveQueue) {
                LiveQueueView(viewModel: viewModel)
            }
        }
    }
    
    // MARK: - Subviews
    
    // 1. Hero Arrival Section
    private var heroArrivalSection: some View {
        VStack(spacing: 12) {
            ZStack {
                // Outer Pulse Ring
                Circle()
                    .fill(Color.mcStatusGreen.opacity(0.12))
                    .frame(width: 88, height: 88)
                
                // Middle Ring
                Circle()
                    .fill(Color.mcStatusGreen.opacity(0.2))
                    .frame(width: 72, height: 72)
                
                // Solid Inner Icon
                Circle()
                    .fill(Color.mcStatusGreen)
                    .frame(width: 56, height: 56)
                    .shadow(color: Color.mcStatusGreen.opacity(0.3), radius: 8, x: 0, y: 4)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            VStack(spacing: 6) {
                Text("You're Checked In")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.mcTextPrimary)
                
                Text("Your arrival was automatically detected upon entering \(viewModel.clinicName).")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.mcTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .padding(.horizontal, 16)
            }
        }
    }
    
    // 2. Queue Number Card (Figma Page 7)
    private var queueNumberCard: some View {
        VStack(spacing: 16) {
            
            // Header: Token Label & Confirmed Badge
            HStack {
                Text("YOUR QUEUE NUMBER")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.mcTextLabel)
                    .tracking(0.6)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.mcStatusGreen)
                        .frame(width: 6, height: 6)
                    Text("Confirmed · In Line")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.mcStatusGreen)
                }
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background(Color.mcStatusGreenBg)
                .clipShape(Capsule())
            }
            
            // Huge Token Number
            Text(viewModel.patientQueueNumber)
                .font(.system(size: 54, weight: .heavy, design: .rounded))
                .foregroundStyle(Color.mcTeal)
                .padding(.vertical, -4)
            
            Divider()
                .background(Color.mcBorderLight)
            
            // 3-Metric Row (Ahead, Wait, Now Serving)
            HStack(spacing: 12) {
                
                // Metric 1: People Ahead
                VStack(spacing: 4) {
                    Text("PEOPLE AHEAD")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.mcTextLabel)
                    
                    Text("\(viewModel.peopleAheadCount)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.mcTextPrimary)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: 32)
                
                // Metric 2: Est Wait
                VStack(spacing: 4) {
                    Text("EST. WAIT")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.mcTextLabel)
                    
                    Text("~\(viewModel.estimatedWaitMinutes) mins")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.mcTextPrimary)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: 32)
                
                // Metric 3: Now Serving
                VStack(spacing: 4) {
                    Text("NOW SERVING")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.mcTextLabel)
                    
                    Text(viewModel.nowServingNumber)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.mcTeal)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.mcTealBorder, lineWidth: 1.5)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }
    
    // 3. Attending Specialist Banner
    private var attendingDoctorBanner: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.mcTealLight)
                    .frame(width: 48, height: 48)
                
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(Color.mcTeal)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 4) {
                    Text(viewModel.doctorName)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Color.mcTextPrimary)
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.mcStatusGreen)
                }
                
                Text(viewModel.doctorSpecialty)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.mcTextSecondary)
                
                Text("\(viewModel.roomNumber) · \(viewModel.clinicName)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.mcTeal)
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
    }
    
    // 4. Waiting Lounge Guidance & Amenities
    private var loungeGuidanceCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(spacing: 8) {
                Image(systemName: "chair.lounge.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.mcTeal)
                
                Text("Waiting Lounge Guidance")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.mcTextPrimary)
            }
            
            Text("Please proceed to \(viewModel.waitingLounge). You can relax while waiting for your token to be called.")
                .font(.system(size: 12))
                .foregroundStyle(Color.mcTextSecondary)
                .lineSpacing(2)
            
            VStack(alignment: .leading, spacing: 6) {
                amenityRow(icon: "wifi", text: "Free Guest Wi-Fi: '\(viewModel.wifiNetwork)' (Pass: \(viewModel.wifiPassword))")
                amenityRow(icon: "cup.and.saucer.fill", text: "Complimentary drinking water & tea station near lounge")
                amenityRow(icon: "speaker.wave.2.fill", text: "High-priority chime will sound when Doctor calls your number")
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color.mcTealLight.opacity(0.45))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.mcTealBorder, lineWidth: 1)
        )
    }
    
    private func amenityRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundStyle(Color.mcTeal)
                .frame(width: 16, height: 16)
            
            Text(text)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Color.mcTextPrimary)
                .lineSpacing(1)
            
            Spacer()
        }
    }
    
    // 5. Action Buttons
    private var actionButtonsSection: some View {
        VStack(spacing: 10) {
            Button {
                navigateToLiveQueue = true
            } label: {
                HStack(spacing: 8) {
                    Text("View Live Queue")
                        .font(.system(size: 16, weight: .bold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .foregroundStyle(.white)
                .background(Color.mcTeal)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: Color.mcTeal.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(.plain)
            
            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.mcTextSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
            }
            .buttonStyle(.plain)
        }
    }
}

#if DEBUG
struct CheckInSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInSuccessView()
    }
}
#endif
