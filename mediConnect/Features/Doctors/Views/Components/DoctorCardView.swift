// DoctorCardView.swift
// MediConnect — Features/Doctors/Views/Components
//
// Specialist Doctor Card component matching Figma specifications.

import SwiftUI

struct DoctorCardView: View {
    
    let doctor: Doctor
    var onSelect: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Top Header Row
            HStack(alignment: .top, spacing: 14) {
                    
                    // Doctor Avatar
                    ZStack {
                        Circle()
                            .fill(Color.mcTealLight)
                            .frame(width: 58, height: 58)
                        
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 54))
                            .foregroundStyle(Color.mcTeal)
                    }
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
                    
                    // Doctor Meta Info
                    VStack(alignment: .leading, spacing: 3) {
                        Text(doctor.user.fullName)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.mcTextPrimary)
                        
                        Text(doctor.displayTitle)
                            .font(.system(size: 13))
                            .foregroundStyle(Color.mcTextSecondary)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "cross.case.fill")
                                .font(.system(size: 11))
                                .foregroundStyle(Color.mcTeal)
                            
                            Text(doctor.clinicName)
                                .font(.system(size: 12))
                                .foregroundStyle(Color.mcTextSecondary)
                        }
                        .padding(.top, 1)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.mcTextSecondary.opacity(0.6))
                        .padding(.top, 4)
                }
                
                // Next Available Badge
                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.system(size: 11, weight: .medium))
                    
                    Text("Next available · \(doctor.nextAvailableSlotText)")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundStyle(Color.mcTeal)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.mcTealLight)
                .clipShape(Capsule())
                
                // Distance & Location Footer
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(Color.mcTextSecondary)
                    
                    Text(doctor.formattedDistance)
                        .font(.system(size: 11))
                        .foregroundStyle(Color.mcTextSecondary)
                    
                    Spacer()
                    
                    Text(doctor.formattedFee)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Color.mcTextPrimary)
                }
                .padding(.top, 2)
            }
            .padding(14)
            .background(Color.mcCardBg)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.mcBorderLight, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
            .contentShape(Rectangle())
    }
}

#if DEBUG
struct DoctorCardView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorCardView(doctor: Doctor.mockDoctors[0]) {}
            .padding()
    }
}
#endif
