// HomeView.swift
// MediConnect — Features/Dashboard/Views
//
// Patient Home Dashboard matching Figma specifications:
// - Top Greeting Header with user avatar
// - "Next Appointment" Hero Card with status pills
// - "Find a Doctor →" Primary CTA Banner
// - Specialties Horizontal Carousel
// - Nearby Clinics with real-time distance indicators

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // Binding to control parent tab switching
    var onTabSelect: ((Int) -> Void)? = nil
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                
                // MARK: - 1. Top Header
                headerSection
                    .padding(.top, 8)
                
                // MARK: - 2. Next Appointment Hero Card
                if let appointment = viewModel.nextAppointment {
                    nextAppointmentSection(appointment: appointment)
                }
                
                // MARK: - 3. Find a Doctor Quick CTA
                findDoctorCTA
                
                // MARK: - 4. Specialties Carousel
                specialtiesSection
                
                // MARK: - 5. Nearby Clinics Section
                nearbyClinicsSection
                    .padding(.bottom, 24)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.mcAppBg.ignoresSafeArea())
        .hideNavigationBar()
    }
    
    // MARK: - Subviews
    
    // 1. Header
    private var headerSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.greeting(for: authViewModel.currentUser))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.mcTextPrimary)
                
                Text("How can we help you today?")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.mcTextSecondary)
            }
            
            Spacer()
            
            // Patient Avatar
            Button {
                onTabSelect?(4) // Switch to Profile Tab
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.mcTealLight)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(Color.mcTeal)
                }
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
            }
            .buttonStyle(.plain)
        }
    }
    
    // 2. Next Appointment Hero Card
    private func nextAppointmentSection(appointment: Appointment) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Section Title & "See All"
            HStack {
                Text("Next Appointment")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.mcTextPrimary)
                
                Spacer()
                
                Button {
                    onTabSelect?(2) // Switch to Appointments Tab
                } label: {
                    Text("See All")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.mcTeal)
                }
                .buttonStyle(.plain)
            }
            
            // Appointment Card
            VStack(alignment: .leading, spacing: 14) {
                
                // Badges Row
                HStack {
                    // Specialty Chip
                    Text(appointment.doctor?.specialization.rawValue ?? "Cardiology")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.mcTeal)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.mcTealLight)
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    // Status Pill
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.mcStatusGreen)
                            .frame(width: 6, height: 6)
                        
                        Text(appointment.status.displayName)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(Color.mcStatusGreen)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.mcStatusGreenBg)
                    .clipShape(Capsule())
                }
                
                // Doctor Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.doctor?.user.fullName ?? "Dr. Sarah Perera")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color.mcTextPrimary)
                    
                    Text(appointment.doctor?.subSpecialty ?? "Cardiology Specialist")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.mcTextSecondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.mcTeal)
                        
                        Text(appointment.clinicName)
                            .font(.system(size: 12))
                            .foregroundStyle(Color.mcTextSecondary)
                    }
                    .padding(.top, 2)
                }
                
                // Date & Time Banner
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.mcTeal)
                    
                    Text(appointment.formattedHeroSchedule)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.mcTextPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.mcTealLight.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                // View Details Button
                Button {
                    onTabSelect?(2) // View appointment details
                } label: {
                    HStack(spacing: 4) {
                        Text("View Details")
                            .font(.system(size: 13, weight: .semibold))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundStyle(Color.mcTeal)
                    .frame(maxWidth: .infinity)
                    .frame(height: 38)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.mcTealBorder, lineWidth: 1)
                    )
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
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        }
    }
    
    // 3. Find Doctor Quick CTA Button
    private var findDoctorCTA: some View {
        Button {
            onTabSelect?(1) // Switch to Doctors Tab
        } label: {
            HStack {
                Text("Find a Doctor")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 20)
            .frame(height: 52)
            .background(Color.mcTeal)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: Color.mcTeal.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
    
    // 4. Specialties Carousel
    private var specialtiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Specialties")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.mcTextPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.specialties, id: \.self) { specialty in
                        let isSelected = viewModel.selectedSpecialty == specialty
                        
                        Button {
                            viewModel.selectSpecialty(specialty)
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: specialty.icon)
                                    .font(.system(size: 14))
                                    .foregroundStyle(isSelected ? .white : Color.mcTeal)
                                
                                Text(specialty.rawValue)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(isSelected ? .white : Color.mcTextPrimary)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(isSelected ? Color.mcTeal : Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isSelected ? Color.mcTeal : Color.mcBorderLight, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    // 5. Nearby Clinics Section
    private var nearbyClinicsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Header Row
            HStack {
                Text("Nearby Clinics")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.mcTextPrimary)
                
                Spacer()
                
                Button {
                    onTabSelect?(3) // Switch to Map Tab
                } label: {
                    Text("View Map")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.mcTeal)
                }
                .buttonStyle(.plain)
            }
            
            // Clinics List Cards
            VStack(spacing: 10) {
                ForEach(viewModel.nearbyClinics) { clinic in
                    Button {
                        onTabSelect?(3) // Navigate to Map with selected clinic
                    } label: {
                        HStack(spacing: 12) {
                            
                            // Hospital Icon Container
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.mcTealLight)
                                    .frame(width: 44, height: 44)
                                
                                Image(systemName: "cross.case.fill")
                                    .font(.system(size: 18))
                                    .foregroundStyle(Color.mcTeal)
                            }
                            
                            // Clinic Name & Address
                            VStack(alignment: .leading, spacing: 3) {
                                Text(clinic.name)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(Color.mcTextPrimary)
                                
                                Text(clinic.city)
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.mcTextSecondary)
                            }
                            
                            Spacer()
                            
                            // Distance Badge
                            HStack(spacing: 3) {
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 11, weight: .bold))
                                Text(clinic.formattedDistance)
                                    .font(.system(size: 12, weight: .semibold))
                            }
                            .foregroundStyle(Color.mcTeal)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.mcTealLight.opacity(0.6))
                            .clipShape(Capsule())
                        }
                        .padding(12)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.mcBorderLight, lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 1)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthViewModel())
    }
}
#endif
