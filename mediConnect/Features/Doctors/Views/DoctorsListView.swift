// DoctorsListView.swift
// MediConnect — Features/Doctors/Views
//
// Doctor Directory & Discovery Screen matching Figma specifications:
// - Real-time Search and Filter chips
// - Sort by Distance, Rating, and Fee
// - Specialist Doctor Cards with next available slots
// - Medical Council Verified Credentials Disclaimer

import SwiftUI

struct DoctorsListView: View {
    
    @StateObject private var viewModel = DoctorViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    
                    // MARK: - 1. Search Bar
                    searchBar
                        .padding(.top, 4)
                    
                    // MARK: - 2. Filter Chips Row
                    filterChipsRow
                    
                    // MARK: - 3. Results Header & Sort Menu
                    resultsHeaderRow
                    
                    // MARK: - 4. Doctors List Cards
                    doctorsListSection
                    
                    // MARK: - 5. Verified Credentials Notice
                    verifiedCredentialsBanner
                        .padding(.top, 8)
                        .padding(.bottom, 24)
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Doctors")
            .inlineNavigationBarTitle()
            .background(Color.mcAppBg.ignoresSafeArea())
        }
    }
    
    // MARK: - Subviews
    
    // 1. Search Bar
    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15))
                .foregroundStyle(Color.mcTextSecondary)
            
            TextField("Search by doctor, hospital, or specialty...", text: $viewModel.searchText)
                .font(.system(size: 14))
                .foregroundStyle(Color.mcTextPrimary)
                .autocorrectionDisabled()
            
            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.mcTextSecondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.mcBorderLight, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 1)
    }
    
    // 2. Filter Chips Row (Figma Page 5)
    private var filterChipsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                
                // Filters Counter Chip
                HStack(spacing: 4) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 11, weight: .bold))
                    Text("Filters (\(viewModel.activeFilterCount))")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundStyle(Color.mcTextPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(Color.white)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.mcBorderLight, lineWidth: 1)
                )
                
                // Specialty Active Chip
                if let specialty = viewModel.selectedSpecialty {
                    Button {
                        viewModel.selectedSpecialty = nil
                    } label: {
                        HStack(spacing: 4) {
                            Text(specialty.rawValue)
                                .font(.system(size: 12, weight: .semibold))
                            Image(systemName: "xmark")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(Color.mcTeal)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
                
                // Within 5km Chip Toggle
                Button {
                    if viewModel.maxDistanceKm == nil {
                        viewModel.maxDistanceKm = 5.0
                    } else {
                        viewModel.maxDistanceKm = nil
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .font(.system(size: 10, weight: .bold))
                        Text("Within 5 km")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(viewModel.maxDistanceKm != nil ? Color.mcTeal : Color.mcTextPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(viewModel.maxDistanceKm != nil ? Color.mcTealLight : Color.white)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(viewModel.maxDistanceKm != nil ? Color.mcTealBorder : Color.mcBorderLight, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
                
                // Next Available Chip Toggle
                Button {
                    viewModel.onlyNextAvailable.toggle()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 10, weight: .bold))
                        Text("Next available")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(viewModel.onlyNextAvailable ? Color.mcTeal : Color.mcTextPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(viewModel.onlyNextAvailable ? Color.mcTealLight : Color.white)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(viewModel.onlyNextAvailable ? Color.mcTealBorder : Color.mcBorderLight, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // 3. Results Header & Sort Menu
    private var resultsHeaderRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.selectedSpecialty != nil ? "Available \(viewModel.selectedSpecialty!.rawValue)s" : "Available Doctors")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Color.mcTextPrimary)
                
                Text("\(viewModel.filteredDoctors.count) doctors nearby")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.mcTextSecondary)
            }
            
            Spacer()
            
            // Sort Dropdown Menu
            Menu {
                ForEach(DoctorSortOption.allCases) { option in
                    Button {
                        viewModel.sortOption = option
                    } label: {
                        HStack {
                            Text(option.rawValue)
                            if viewModel.sortOption == option {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(viewModel.sortOption.rawValue)
                        .font(.system(size: 12, weight: .semibold))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .bold))
                }
                .foregroundStyle(Color.mcTextPrimary)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.mcBorderLight, lineWidth: 1)
                )
            }
        }
        .padding(.top, 4)
    }
    
    // 4. Doctor Cards List
    private var doctorsListSection: some View {
        VStack(spacing: 12) {
            if viewModel.filteredDoctors.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 32))
                        .foregroundStyle(Color.mcTextSecondary)
                        .padding(.top, 24)
                    
                    Text("No matching specialists found")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.mcTextPrimary)
                    
                    Text("Try adjusting your search query, specialty filter, or distance radius.")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.mcTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .padding(.bottom, 24)
            } else {
                ForEach(viewModel.filteredDoctors) { doctor in
                    NavigationLink {
                        DoctorProfileView(doctor: doctor)
                    } label: {
                        DoctorCardView(doctor: doctor) {}
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // 5. Verified Credentials Banner (Figma Page 5 Footer)
    private var verifiedCredentialsBanner: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 16))
                .foregroundStyle(Color.mcStatusGreen)
                .padding(.top, 1)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Verified Clinical Credentials")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Color.mcTextPrimary)
                
                Text("All practicing specialists hold certified licenses registered with the Medical Council.")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.mcTextSecondary)
                    .lineSpacing(1.5)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.mcStatusGreenBg.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.mcStatusGreen.opacity(0.2), lineWidth: 1)
        )
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
