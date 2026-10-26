// DoctorsListView.swift
// MediConnect — Features/Doctors/Views
//
// Doctor directory & search screen (Phase 3 Foundation).

import SwiftUI

struct DoctorsListView: View {
    
    @State private var searchText: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Search Header placeholder
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color.mcTextSecondary)
                    TextField("Search doctors, specialties...", text: $searchText)
                        .font(.system(size: 15))
                }
                .padding(12)
                .background(Color.mcInputBg)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // Doctor Cards List
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(Doctor.mockDoctors) { doctor in
                            doctorCard(doctor)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Doctors")
            .inlineNavigationBarTitle()
            .background(Color.mcAppBg.ignoresSafeArea())
        }
    }
    
    @ViewBuilder
    private func doctorCard(_ doctor: Doctor) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.mcTealLight)
                    .frame(width: 54, height: 54)
                
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Color.mcTeal)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(doctor.user.fullName)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Color.mcTextPrimary)
                
                Text(doctor.displayTitle)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.mcTextSecondary)
                
                Text(doctor.clinicName)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.mcTextSecondary)
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 10))
                    Text(doctor.nextAvailableSlotText)
                        .font(.system(size: 11, weight: .medium))
                }
                .foregroundStyle(Color.mcTeal)
                .padding(.top, 2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.mcTextSecondary)
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
}

#if DEBUG
struct DoctorsListView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorsListView()
            .environmentObject(AuthViewModel())
    }
}
#endif
