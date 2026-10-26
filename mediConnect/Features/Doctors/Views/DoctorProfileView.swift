// DoctorProfileView.swift
// MediConnect — Features/Doctors/Views
//
// Doctor Profile & Appointment Slot Picker View matching Figma specifications:
// - Doctor Credentials and Verified Badge
// - About & Experience Bio
// - Horizontal Date Selection Strip (Mon–Fri)
// - Available Time Slots Grid with Open / Selected / Booked legend
// - Consultation Fee summary and "Next →" primary action

import SwiftUI

struct DoctorProfileView: View {
    
    let doctor: Doctor
    @StateObject private var viewModel = DoctorViewModel()
    @Environment(\.dismiss) private var dismiss
    
    // Callback when user taps "Next →" to proceed to booking details (Phase 4)
    var onProceedToBooking: ((Doctor, Date, TimeSlot?) -> Void)? = nil
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 22) {
                
                // MARK: - 1. Doctor Header Card
                doctorHeaderCard
                    .padding(.top, 8)
                
                // MARK: - 2. About Section
                aboutSection
                
                // MARK: - 3. Date & Time Selection Section
                dateTimeSelectionSection
                
                // MARK: - 4. Bottom Fee & Action Bar
                bookingActionBar
                    .padding(.bottom, 24)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.mcAppBg.ignoresSafeArea())
        .navigationTitle("Doctor Profile")
        .inlineNavigationBarTitle()
        .onAppear {
            viewModel.selectDoctor(doctor)
        }
    }
    
    // MARK: - Subviews
    
    // 1. Doctor Header Card
    private var doctorHeaderCard: some View {
        VStack(spacing: 12) {
            
            // Avatar with verified badge
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.mcTealLight)
                    .frame(width: 84, height: 84)
                
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(Color.mcTeal)
                
                // Verified Badge
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(Color.mcStatusGreen)
                    .background(Circle().fill(Color.white).frame(width: 20, height: 20))
                    .offset(x: 2, y: 2)
            }
            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
            
            // Name & Title
            VStack(spacing: 4) {
                Text(doctor.user.fullName)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.mcTextPrimary)
                
                Text(doctor.displayTitle)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.mcTextSecondary)
                
                // Clinic Location & Distance
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.mcTeal)
                    
                    Text("\(doctor.clinicName) · \(doctor.locationArea)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.mcTextSecondary)
                }
                .padding(.top, 2)
            }
            
            // Stats Row: Rating, Experience, Reviews
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.mcStatusOrange)
                    Text("\(doctor.formattedRating) (\(doctor.reviewCount))")
                        .font(.system(size: 12, weight: .semibold))
                }
                
                Text("•")
                    .foregroundStyle(Color.mcBorderLight)
                
                Text("\(doctor.yearsOfExperience) yrs experience")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.mcTextSecondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(Color.mcTealLight.opacity(0.6))
            .clipShape(Capsule())
            .padding(.top, 2)
        }
        .frame(maxWidth: .infinity)
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.mcBorderLight, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
    }
    
    // 2. About Section
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "person.text.rectangle")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.mcTeal)
                
                Text("About")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.mcTextPrimary)
            }
            
            Text(doctor.bio)
                .font(.system(size: 13))
                .foregroundStyle(Color.mcTextSecondary)
                .lineSpacing(3)
            
            // Qualifications Tag Cloud
            if !doctor.qualifications.isEmpty {
                HStack(spacing: 6) {
                    ForEach(doctor.qualifications, id: \.self) { qual in
                        Text(qual)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(Color.mcTeal)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.mcTealLight)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
                .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.mcBorderLight, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
    }
    
    // 3. Date & Time Selection Section
    private var dateTimeSelectionSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            // Section Title & Step Indicator
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.mcTeal)
                    
                    Text("Selected Appointment")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.mcTextPrimary)
                }
                
                Spacer()
                
                Text("Confirmed Step 1 of 2")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(Color.mcTeal)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.mcTealLight)
                    .clipShape(Capsule())
            }
            
            Text("Select Date & Time")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.mcTextSecondary)
            
            // Horizontal Date Selection Strip (Mon-Fri)
            HStack(spacing: 8) {
                ForEach(viewModel.availableDays) { day in
                    let isSelected = Calendar.current.isDate(day.date, inSameDayAs: viewModel.selectedDate)
                    
                    Button {
                        viewModel.selectDay(day)
                    } label: {
                        VStack(spacing: 6) {
                            Text(day.dayName)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(isSelected ? .white.opacity(0.9) : Color.mcTextSecondary)
                            
                            Text(day.dayNumber)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(isSelected ? .white : Color.mcTextPrimary)
                            
                            Circle()
                                .fill(isSelected ? .white : Color.mcTeal)
                                .frame(width: 4, height: 4)
                                .opacity(isSelected ? 1.0 : 0.0)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(isSelected ? Color.mcTeal : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isSelected ? Color.mcTeal : Color.mcBorderLight, lineWidth: 1)
                        )
                        .shadow(color: isSelected ? Color.mcTeal.opacity(0.2) : Color.clear, radius: 4, x: 0, y: 2)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            // Available Times Header & Legend
            HStack {
                Text("Available Times")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.mcTextPrimary)
                
                Spacer()
                
                // Legend
                HStack(spacing: 8) {
                    legendItem(title: "Open", color: Color.mcBorderLight)
                    legendItem(title: "Selected", color: Color.mcTeal)
                    legendItem(title: "Booked", color: Color.gray.opacity(0.4))
                }
            }
            .padding(.top, 4)
            
            // Time Slots Grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(viewModel.availableSlots) { slot in
                    let isSelected = viewModel.selectedTimeSlot?.id == slot.id
                    let isBooked = slot.isBooked
                    
                    Button {
                        viewModel.selectSlot(slot)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(slot.timeString)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(
                                        isBooked ? Color.gray.opacity(0.6) :
                                        isSelected ? .white : Color.mcTextPrimary
                                    )
                                
                                Text(isBooked ? "Booked" : isSelected ? "Selected" : "Available")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundStyle(
                                        isBooked ? Color.gray.opacity(0.6) :
                                        isSelected ? .white.opacity(0.9) : Color.mcTeal
                                    )
                            }
                            
                            Spacer()
                            
                            if isBooked {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 11))
                                    .foregroundStyle(Color.gray.opacity(0.5))
                            } else if isSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 13))
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(
                            isBooked ? Color.mcInputBg :
                            isSelected ? Color.mcTeal : Color.white
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    isSelected ? Color.mcTeal : Color.mcBorderLight,
                                    lineWidth: isSelected ? 1.5 : 1
                                )
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(isBooked)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.mcBorderLight, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
    }
    
    // 4. Booking Action Bar
    private var bookingActionBar: some View {
        VStack(spacing: 12) {
            
            // Fee Row
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Consultation Fee")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.mcTextSecondary)
                    
                    Text("Payable at clinic or online")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.mcTextSecondary.opacity(0.8))
                }
                
                Spacer()
                
                Text(doctor.formattedFee)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.mcTextPrimary)
            }
            .padding(.horizontal, 4)
            
            // "Next →" Primary Button
            MCPrimaryButton(
                title: "Next →",
                isDisabled: viewModel.selectedTimeSlot == nil
            ) {
                onProceedToBooking?(doctor, viewModel.selectedDate, viewModel.selectedTimeSlot)
            }
            
            // Policy Note
            HStack(spacing: 4) {
                Image(systemName: "shield.lefthalf.filled")
                    .font(.system(size: 11))
                Text("Free cancellation up to 2 hours before appointment")
                    .font(.system(size: 11))
            }
            .foregroundStyle(Color.mcTextSecondary)
            .padding(.top, 2)
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.mcBorderLight, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
    
    // Helper Legend Item
    @ViewBuilder
    private func legendItem(title: String, color: Color) -> some View {
        HStack(spacing: 3) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
            Text(title)
                .font(.system(size: 10))
                .foregroundStyle(Color.mcTextSecondary)
        }
    }
}

#if DEBUG
struct DoctorProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DoctorProfileView(doctor: Doctor.mockDoctors[0])
        }
    }
}
#endif
