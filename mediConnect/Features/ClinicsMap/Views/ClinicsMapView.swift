// ClinicsMapView.swift
// MediConnect — Features/ClinicsMap/Views
//
// Clinic Discovery Map tab matching Figma specifications:
// - Top location indicator
// - Search & Filter chips
// - Clinic list and preview card with "Get Directions"

import SwiftUI

struct ClinicsMapView: View {
    
    @State private var searchText: String = ""
    @State private var selectedClinic: Clinic = Clinic.mockClinics[0]
    @State private var selectedFilter: String = "All Clinics"
    
    let filters = ["All Clinics", "Cardiology", "Emergency Care"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // Top Precise Location Bar
                HStack {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.mcStatusGreen)
                            .frame(width: 8, height: 8)
                        
                        Text("Using Precise Location · Colombo 04")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color.mcTextSecondary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color.mcTextSecondary)
                    
                    TextField("Search clinics, specialties, or areas...", text: $searchText)
                        .font(.system(size: 14))
                }
                .padding(12)
                .background(Color.mcInputBg)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(filters, id: \.self) { filter in
                            let isSelected = selectedFilter == filter
                            
                            Button {
                                selectedFilter = filter
                            } label: {
                                Text(filter)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(isSelected ? .white : Color.mcTextPrimary)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .background(isSelected ? Color.mcTeal : Color.white)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(isSelected ? Color.mcTeal : Color.mcBorderLight, lineWidth: 1)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
                
                // Clinics List / Map Presentation
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(Clinic.mockClinics) { clinic in
                            let isSelected = selectedClinic.id == clinic.id
                            
                            Button {
                                selectedClinic = clinic
                            } label: {
                                HStack(spacing: 12) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(isSelected ? Color.mcTeal : Color.mcTealLight)
                                            .frame(width: 46, height: 46)
                                        
                                        Image(systemName: "building.2.fill")
                                            .font(.system(size: 18))
                                            .foregroundStyle(isSelected ? .white : Color.mcTeal)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(clinic.name)
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundStyle(Color.mcTextPrimary)
                                        
                                        Text(clinic.address)
                                            .font(.system(size: 12))
                                            .foregroundStyle(Color.mcTextSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 3) {
                                        Text(clinic.formattedDistance)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundStyle(Color.mcTeal)
                                        
                                        Text(clinic.formattedDriveTime)
                                            .font(.system(size: 11))
                                            .foregroundStyle(Color.mcTextSecondary)
                                    }
                                }
                                .padding(14)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(isSelected ? Color.mcTeal : Color.mcBorderLight, lineWidth: isSelected ? 1.5 : 1)
                                )
                                .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 1)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 6)
                }
                
                // Selected Clinic Bottom Action Card (matching Figma Page 8)
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(selectedClinic.name)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(Color.mcTextPrimary)
                            
                            if let sub = selectedClinic.subtitle {
                                Text(sub)
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.mcTextSecondary)
                            }
                            
                            Text("\(selectedClinic.formattedDistance) · \(selectedClinic.formattedDriveTime) · \(selectedClinic.openingHours)")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.mcTeal)
                                .padding(.top, 2)
                        }
                        
                        Spacer()
                    }
                    
                    // Action Buttons Row
                    HStack(spacing: 10) {
                        Button {
                            // Get Directions action
                        } label: {
                            HStack {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 13))
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
                }
                .padding(16)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.mcBorderLight, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: -2)
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            }
            .navigationTitle("Clinic Map")
            .inlineNavigationBarTitle()
            .background(Color.mcAppBg.ignoresSafeArea())
        }
    }
}

#if DEBUG
struct ClinicsMapView_Previews: PreviewProvider {
    static var previews: some View {
        ClinicsMapView()
    }
}
#endif
