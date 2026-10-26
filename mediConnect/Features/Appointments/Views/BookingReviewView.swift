// BookingReviewView.swift
// MediConnect — Features/Appointments/Views
//
// Booking Review & Cost Breakdown View:
// - Specialist & Clinic summary
// - Patient Registry details verification
// - Itemized fee breakdown in LKR
// - "Confirm Booking →" primary action creating confirmed appointment record

import SwiftUI

struct BookingReviewView: View {
    
    @ObservedObject var bookingViewModel: BookingViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var navigateToDetail: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                
                // 1. Specialist & Schedule Summary Card
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text("APPOINTMENT SUMMARY")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(Color.mcTextLabel)
                            .tracking(0.5)
                        
                        Spacer()
                        
                        Text("Step 2 of 2")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(Color.mcTeal)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.mcTealLight)
                            .clipShape(Capsule())
                    }
                    
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.mcTealLight)
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 44))
                                .foregroundStyle(Color.mcTeal)
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text(bookingViewModel.doctor?.user.fullName ?? "Dr. Nimal Perera")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(Color.mcTextPrimary)
                            
                            Text(bookingViewModel.doctor?.displayTitle ?? "Cardiologist - Adult Interventional")
                                .font(.system(size: 13))
                                .foregroundStyle(Color.mcTextSecondary)
                            
                            Text(bookingViewModel.doctor?.clinicName ?? "Lanka Heart Care Clinic")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.mcTeal)
                        }
                    }
                    
                    Divider()
                    
                    // Date & Time Row
                    HStack(spacing: 12) {
                        Image(systemName: "calendar.badge.clock")
                            .font(.system(size: 16))
                            .foregroundStyle(Color.mcTeal)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            let slotTime = bookingViewModel.selectedSlot?.timeString ?? "4:00 PM"
                            Text("\(bookingViewModel.selectedDate.friendlyDate) at \(slotTime)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.mcTextPrimary)
                            
                            Text("In-Person Consultation (~20 mins)")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.mcTextSecondary)
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
                .shadow(color: Color.black.opacity(0.02), radius: 6, x: 0, y: 2)
                
                // 2. Patient Information Review Card
                VStack(alignment: .leading, spacing: 12) {
                    Text("PATIENT DETAILS")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.mcTextLabel)
                        .tracking(0.5)
                    
                    VStack(spacing: 10) {
                        reviewRow(label: "Name", value: bookingViewModel.patientFullName)
                        reviewRow(label: "Age / Gender", value: "\(bookingViewModel.patientAge) yrs · \(bookingViewModel.patientGender)")
                        reviewRow(label: "NIC / Passport", value: bookingViewModel.nicOrPassport)
                        reviewRow(label: "Contact", value: "+94 \(bookingViewModel.contactNumber)")
                        reviewRow(label: "Address", value: bookingViewModel.homeAddress)
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
                
                // 3. Fee Breakdown Card
                VStack(alignment: .leading, spacing: 12) {
                    Text("PAYMENT SUMMARY")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.mcTextLabel)
                        .tracking(0.5)
                    
                    VStack(spacing: 8) {
                        feeRow(title: "Doctor Consultation Fee", amount: bookingViewModel.formattedConsultationFee)
                        feeRow(title: "Hospital Service & Registry", amount: bookingViewModel.formattedServiceFee)
                        
                        Divider().padding(.vertical, 4)
                        
                        HStack {
                            Text("Total Payable")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(Color.mcTextPrimary)
                            
                            Spacer()
                            
                            Text(bookingViewModel.formattedTotalFee)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(Color.mcTeal)
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
                .shadow(color: Color.black.opacity(0.02), radius: 6, x: 0, y: 2)
                
                // Error Banner
                if let error = bookingViewModel.errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(Color.mcStatusRed)
                        Text(error)
                            .font(.system(size: 12))
                            .foregroundStyle(Color.mcStatusRed)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.mcStatusRed.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                // Confirm Booking Action Button
                MCPrimaryButton(
                    title: "Confirm Booking →",
                    isLoading: bookingViewModel.isSubmitting
                ) {
                    Task {
                        await bookingViewModel.confirmBooking()
                        if bookingViewModel.isBookingConfirmed {
                            navigateToDetail = true
                        }
                    }
                }
                .padding(.top, 4)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.mcAppBg.ignoresSafeArea())
        .navigationTitle("Review Booking")
        .inlineNavigationBarTitle()
        .navigationDestination(isPresented: $navigateToDetail) {
            if let appointment = bookingViewModel.confirmedAppointment {
                AppointmentDetailView(appointment: appointment)
            }
        }
    }
    
    @ViewBuilder
    private func reviewRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.system(size: 13))
                .foregroundStyle(Color.mcTextSecondary)
                .frame(width: 110, alignment: .leading)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.mcTextPrimary)
                .multilineTextAlignment(.trailing)
        }
    }
    
    @ViewBuilder
    private func feeRow(title: String, amount: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 13))
                .foregroundStyle(Color.mcTextSecondary)
            
            Spacer()
            
            Text(amount)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.mcTextPrimary)
        }
    }
}

#if DEBUG
struct BookingReviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BookingReviewView(bookingViewModel: BookingViewModel())
                .environmentObject(AuthViewModel())
        }
    }
}
#endif
