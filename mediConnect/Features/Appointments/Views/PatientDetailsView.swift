// PatientDetailsView.swift
// MediConnect — Features/Appointments/Views
//
// Patient Information Fill screen matching Figma specifications (Page 6):
// - Full Name, Age, Gender Picker
// - Sri Lankan NIC / Passport validation (e.g. 199234509821 or 923450982V)
// - +94 Sri Lankan phone format with SMS reminder notice
// - Home Address & Optional Symptoms Note
// - "Continue to Review →" primary navigation

import SwiftUI

struct PatientDetailsView: View {
    
    @ObservedObject var bookingViewModel: BookingViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var navigateToReview: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                
                // Header Prompt
                Text("Please enter the patient's information to proceed with booking your appointment.")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.mcTextSecondary)
                    .lineSpacing(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 4)
                
                // Form Fields Card
                VStack(spacing: 16) {
                    
                    // 1. Patient Full Name
                    MCInputField(
                        label: "Patient Full Name *",
                        placeholder: "e.g. Kaveen Perera",
                        text: $bookingViewModel.patientFullName
                    )
                    
                    // 2. Age & Gender Row
                    HStack(alignment: .top, spacing: 12) {
                        
                        // Age Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("AGE *")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(Color.mcTextLabel)
                                .tracking(0.5)
                            
                            TextField("e.g. 32", text: $bookingViewModel.patientAge)
                                #if os(iOS)
                                .keyboardType(.numberPad)
                                #endif
                                .font(.system(size: 15))
                                .foregroundStyle(Color.mcTextPrimary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 14)
                                .background(Color.mcInputBg)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.mcBorderLight, lineWidth: 1)
                                )
                        }
                        .frame(width: 100)
                        
                        // Gender Segmented Picker
                        VStack(alignment: .leading, spacing: 6) {
                            Text("GENDER *")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(Color.mcTextLabel)
                                .tracking(0.5)
                            
                            Picker("Gender", selection: $bookingViewModel.patientGender) {
                                Text("Male").tag("Male")
                                Text("Female").tag("Female")
                            }
                            .pickerStyle(.segmented)
                            .padding(.top, 4)
                        }
                    }
                    
                    // 3. NIC or Passport Number (Sri Lankan standard)
                    MCInputField(
                        label: "NIC or Passport Number *",
                        placeholder: "e.g. 199234509821 or 923450982V",
                        text: $bookingViewModel.nicOrPassport,
                        helperText: "For clinic registry & insurance verification"
                    )
                    
                    // 4. Contact Number with +94 Prefix
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("CONTACT NUMBER *")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(Color.mcTextLabel)
                                .tracking(0.5)
                            
                            Spacer()
                            
                            Text("SMS Reminders")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(Color.mcTeal)
                        }
                        
                        HStack(spacing: 8) {
                            // Country Code Pill
                            HStack(spacing: 4) {
                                Text("+94")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(Color.mcTextPrimary)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 14)
                            .background(Color.mcTealLight)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            // Phone Input
                            TextField("077 123 4567", text: $bookingViewModel.contactNumber)
                                #if os(iOS)
                                .keyboardType(.phonePad)
                                #endif
                                .font(.system(size: 15))
                                .foregroundStyle(Color.mcTextPrimary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 14)
                                .background(Color.mcInputBg)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.mcBorderLight, lineWidth: 1)
                                )
                        }
                    }
                    
                    // 5. Home Address
                    MCInputField(
                        label: "Home Address *",
                        placeholder: "No. 24, Flower Road, Colombo 07",
                        text: $bookingViewModel.homeAddress
                    )
                    
                    // 6. Additional Note (Optional)
                    MCInputField(
                        label: "Additional Note",
                        placeholder: "e.g. Symptoms, allergies",
                        text: $bookingViewModel.additionalNotes,
                        helperText: "Optional notes for the attending physician"
                    )
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
                
                // Continue to Review Button
                MCPrimaryButton(
                    title: "Continue to Review →",
                    isDisabled: !bookingViewModel.isPatientDetailsValid
                ) {
                    navigateToReview = true
                }
                .padding(.top, 4)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.mcAppBg.ignoresSafeArea())
        .navigationTitle("Patient Details")
        .inlineNavigationBarTitle()
        .navigationDestination(isPresented: $navigateToReview) {
            BookingReviewView(bookingViewModel: bookingViewModel)
        }
    }
}

#if DEBUG
struct PatientDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PatientDetailsView(bookingViewModel: BookingViewModel())
                .environmentObject(AuthViewModel())
        }
    }
}
#endif
