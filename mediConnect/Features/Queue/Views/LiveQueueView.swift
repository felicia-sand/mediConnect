// LiveQueueView.swift
// MediConnect — Features/Queue/Views
//
// Real-Time Queue Tracker matching Figma specifications (Page 7):
// - Pulsing "LIVE UPDATES" telemetry badge
// - Attending Specialist consultation room status
// - Dual Consultation Flow card: "NOW SERVING: A-07" vs "YOUR NUMBER: A-08"
// - Horizontal Visual Queue Track with avatar indicators (A-05 -> A-10)
// - Clinic audio chime & notification instructions
// - Live Activity & Dynamic Island preview banner (PRD Advanced Feature 03)
// - Coursework evaluation controls ("Advance Queue" simulation)

import SwiftUI

struct LiveQueueView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: QueueViewModel
    @State private var isPulsing = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 18) {
                
                // MARK: - 1. Live Telemetry Badge
                liveTelemetryHeader
                    .padding(.top, 4)
                
                // MARK: - 2. Consultation Flow Dual Card (Figma Page 7)
                consultationFlowCard
                
                // MARK: - 3. Horizontal Visual Queue Track
                visualQueueTrackSection
                
                // MARK: - 4. Waiting Guidance & Sound Chime Notice
                queueInstructionsCard
                
                // MARK: - 5. Dynamic Island & Live Activity Preview Banner
                liveActivityPreviewCard
                
                // MARK: - 6. Coursework Demonstration Simulation Controls
                courseworkSimulationControls
                    .padding(.bottom, 24)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.mcAppBg.ignoresSafeArea())
        .navigationTitle("Live Queue")
        .inlineNavigationBarTitle()
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showTurnAlert) {
            Button("Understood", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
    }
    
    // MARK: - Subviews
    
    // 1. Live Telemetry Header
    private var liveTelemetryHeader: some View {
        HStack {
            HStack(spacing: 6) {
                Circle()
                    .fill(Color.mcStatusGreen)
                    .frame(width: 8, height: 8)
                    .scaleEffect(isPulsing ? 1.3 : 0.8)
                    .opacity(isPulsing ? 1.0 : 0.4)
                
                Text("LIVE UPDATES")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.mcStatusGreen)
                    .tracking(0.8)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.mcStatusGreenBg)
            .clipShape(Capsule())
            
            Spacer()
            
            Text("\(viewModel.clinicName) · \(viewModel.roomNumber)")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.mcTextSecondary)
        }
    }
    
    // 2. Consultation Flow Dual Card (Figma Page 7)
    private var consultationFlowCard: some View {
        VStack(spacing: 16) {
            
            // Attending Doctor Header
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color.mcTealLight)
                        .frame(width: 40, height: 40)
                    Image(systemName: "stethoscope")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.mcTeal)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.doctorName)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Color.mcTextPrimary)
                    
                    Text("\(viewModel.doctorSpecialty) · \(viewModel.roomNumber)")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.mcTextSecondary)
                }
                
                Spacer()
            }
            
            Divider()
                .background(Color.mcBorderLight)
            
            // Dual Token Panels (Now Serving vs Your Number)
            HStack(spacing: 12) {
                
                // Left Panel: NOW SERVING
                VStack(alignment: .leading, spacing: 6) {
                    Text("NOW SERVING")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.mcTextLabel)
                        .tracking(0.5)
                    
                    Text(viewModel.nowServingNumber)
                        .font(.system(size: 34, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color.mcTextPrimary)
                    
                    Text(viewModel.nowServingStatus)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Color.mcStatusGreen)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .background(Color.mcInputBg)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.mcBorderLight, lineWidth: 1)
                )
                
                // Right Panel: YOUR NUMBER
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("YOUR TOKEN")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(viewModel.isCurrentUserTurn ? Color.mcStatusGreen : Color.mcTeal)
                            .tracking(0.5)
                        
                        Spacer()
                        
                        if viewModel.isCurrentUserTurn {
                            Circle()
                                .fill(Color.mcStatusGreen)
                                .frame(width: 6, height: 6)
                        }
                    }
                    
                    Text(viewModel.patientQueueNumber)
                        .font(.system(size: 34, weight: .heavy, design: .rounded))
                        .foregroundStyle(viewModel.isCurrentUserTurn ? Color.mcStatusGreen : Color.mcTeal)
                    
                    Text(viewModel.isCurrentUserTurn ? "YOUR TURN NOW! 🩺" : "Your Turn Next! · In Line")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(viewModel.isCurrentUserTurn ? Color.mcStatusGreen : Color.mcTeal)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .background(viewModel.isCurrentUserTurn ? Color.mcStatusGreenBg : Color.mcTealLight.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(viewModel.isCurrentUserTurn ? Color.mcStatusGreen : Color.mcTealBorder, lineWidth: 1.5)
                )
            }
            
            // Queue Stats Footer
            HStack(spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 11))
                    Text("\(viewModel.peopleAheadCount) ahead of you")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundStyle(Color.mcTextPrimary)
                
                Text("•")
                    .foregroundStyle(Color.mcBorderLight)
                
                HStack(spacing: 4) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 11))
                    Text(viewModel.isCurrentUserTurn ? "0 mins wait" : "~\(viewModel.estimatedWaitMinutes) mins wait")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundStyle(viewModel.isCurrentUserTurn ? Color.mcStatusGreen : Color.mcTeal)
                
                Text("•")
                    .foregroundStyle(Color.mcBorderLight)
                
                Text("~\(viewModel.averageMinutesPerPatient)m / patient")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.mcTextSecondary)
                
                Spacer()
            }
            .padding(.top, 2)
        }
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.mcBorderLight, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }
    
    // 3. Horizontal Visual Queue Track
    private var visualQueueTrackSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                Text("QUEUE POSITION TRACKER")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.mcTextLabel)
                    .tracking(0.6)
                
                Spacer()
                
                Text("Room 204")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.mcTeal)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.queueTrack) { item in
                        queueTrackPill(for: item)
                    }
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 2)
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
    
    @ViewBuilder
    private func queueTrackPill(for item: QueueSlotItem) -> some View {
        VStack(spacing: 6) {
            
            // Badge / Icon
            ZStack {
                if item.status == .completed {
                    Circle()
                        .fill(Color.mcStatusGreenBg)
                        .frame(width: 44, height: 44)
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.mcStatusGreen)
                } else if item.status == .inConsultation {
                    Circle()
                        .fill(Color.mcTeal)
                        .frame(width: 44, height: 44)
                        .shadow(color: Color.mcTeal.opacity(0.3), radius: 4, x: 0, y: 2)
                    Image(systemName: "cross.case.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(.white)
                } else if item.isCurrentUser {
                    Circle()
                        .fill(Color.mcTeal)
                        .frame(width: 44, height: 44)
                    Text("YOU")
                        .font(.system(size: 11, weight: .heavy))
                        .foregroundStyle(.white)
                } else {
                    Circle()
                        .fill(Color.mcInputBg)
                        .frame(width: 44, height: 44)
                    Image(systemName: "person.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.mcTextSecondary.opacity(0.6))
                }
            }
            .overlay(
                Circle()
                    .stroke(
                        item.isCurrentUser ? Color.mcTeal :
                        (item.status == .inConsultation ? Color.mcStatusGreen : Color.clear),
                        lineWidth: 2
                    )
            )
            
            // Token Label
            Text(item.tokenNumber)
                .font(.system(size: 13, weight: item.isCurrentUser ? .heavy : .bold))
                .foregroundStyle(item.isCurrentUser ? Color.mcTeal : Color.mcTextPrimary)
            
            // Status Pill
            Text(item.status.displayName)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(
                    item.status == .completed ? Color.mcStatusGreen :
                    (item.status == .inConsultation ? Color.mcStatusOrange :
                    (item.isCurrentUser ? Color.mcTeal : Color.mcTextSecondary))
                )
            
            // Slot Time
            Text(item.timeLabel)
                .font(.system(size: 9))
                .foregroundStyle(Color.mcTextSecondary.opacity(0.8))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(item.isCurrentUser ? Color.mcTealLight.opacity(0.4) : Color.mcInputBg)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(item.isCurrentUser ? Color.mcTealBorder : Color.clear, lineWidth: 1)
        )
    }
    
    // 4. Queue Instructions & Notifications Card
    private var queueInstructionsCard: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "speaker.wave.3.fill")
                .font(.system(size: 18))
                .foregroundStyle(Color.mcTeal)
                .frame(width: 32, height: 32)
                .background(Color.mcTealLight)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Sound Chime & Display Alert")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color.mcTextPrimary)
                
                Text("Please stay in or near Waiting Lounge B. An audible chime and high-priority notification will sound on your iPhone and Apple Watch when Doctor Perera calls Token \(viewModel.patientQueueNumber).")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.mcTextSecondary)
                    .lineSpacing(2)
            }
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.mcBorderLight, lineWidth: 1)
        )
    }
    
    // 5. ActivityKit Live Activity Preview Banner (PRD Feature 03)
    private var liveActivityPreviewCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                HStack(spacing: 5) {
                    Image(systemName: "iphone.radiowaves.left.and.right")
                        .font(.system(size: 12))
                    Text("ACTIVITYKIT · DYNAMIC ISLAND & LOCK SCREEN")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(0.5)
                }
                .foregroundStyle(Color.mcTeal)
                
                Spacer()
                
                Text("Active")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(Color.mcStatusGreen)
            }
            
            // Dynamic Island Pill Simulation
            HStack(spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "stethoscope")
                        .font(.system(size: 10))
                        .foregroundStyle(Color.mcTealLight)
                    Text(viewModel.nowServingNumber)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white)
                }
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 9))
                    .foregroundStyle(Color.mcBorderLight)
                
                HStack(spacing: 4) {
                    Text(viewModel.patientQueueNumber)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.mcStatusGreen)
                    Text("(You)")
                        .font(.system(size: 9))
                        .foregroundStyle(Color.white.opacity(0.8))
                }
                
                Spacer()
                
                Text(viewModel.isCurrentUserTurn ? "Enter Room 204" : "~\(viewModel.estimatedWaitMinutes)m wait")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.black)
            .clipShape(Capsule())
            
            Text("Live Activities automatically stream queue movement to the patient's Lock Screen and Dynamic Island in real-time.")
                .font(.system(size: 11))
                .foregroundStyle(Color.mcTextSecondary)
                .lineSpacing(1.5)
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.mcTealBorder, lineWidth: 1)
        )
    }
    
    // 6. Coursework Demonstration Simulation Controls
    private var courseworkSimulationControls: some View {
        VStack(spacing: 10) {
            
            Text("EVALUATION & DEMO CONTROLS")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(Color.mcTextLabel)
                .tracking(0.5)
            
            HStack(spacing: 10) {
                // Advance Queue Button
                Button {
                    viewModel.advanceQueue()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 14))
                        Text(viewModel.nowServingNumber == "A-07" ? "Call Token A-08 (You)" : "Next Patient")
                            .font(.system(size: 13, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .foregroundStyle(.white)
                    .background(Color.mcTeal)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
                
                // Reset Button
                Button {
                    viewModel.resetSimulation()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 12))
                        Text("Reset")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 44)
                    .foregroundStyle(Color.mcTextPrimary)
                    .background(Color.mcInputBg)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.mcBorderLight, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(14)
        .background(Color.mcTealLight.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#if DEBUG
struct LiveQueueView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LiveQueueView(viewModel: QueueViewModel())
        }
    }
}
#endif
