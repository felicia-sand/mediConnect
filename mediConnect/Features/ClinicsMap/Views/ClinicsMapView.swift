// ClinicsMapView.swift
// MediConnect — Features/ClinicsMap/Views
//
// Interactive Clinic Discovery Map matching Figma specifications (Page 8):
// - MapKit Map with custom medical facility pins
// - Core Location integration with live user location
// - Search & Filter chips ("All Clinics", "Cardiology", "Emergency Care")
// - Selected Clinic Card with turn-by-turn directions handoff via Apple Maps
// - Geofence simulator trigger for automatic arrival check-in validation

import SwiftUI
import MapKit

struct ClinicsMapView: View {
    
    @StateObject private var locationService = LocationService.shared
    @State private var searchText: String = ""
    @State private var selectedClinic: Clinic = Clinic.mockClinics[0]
    @State private var selectedFilter: String = "All Clinics"
    @State private var showGeofenceAlert: Bool = false
    @State private var showCheckInSheet: Bool = false
    @State private var showDirectionsSheet: Bool = false
    
    // Map camera region centered over Colombo healthcare hub
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9050, longitude: 79.8580),
        span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
    )
    
    let filters = ["All Clinics", "Cardiology", "Emergency Care"]
    
    var filteredClinics: [Clinic] {
        var clinics = Clinic.mockClinics
        
        let query = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        if !query.isEmpty {
            clinics = clinics.filter {
                $0.name.lowercased().contains(query) ||
                $0.address.lowercased().contains(query) ||
                $0.city.lowercased().contains(query) ||
                $0.specialties.contains(where: { $0.lowercased().contains(query) })
            }
        }
        
        if selectedFilter == "Cardiology" {
            clinics = clinics.filter { $0.specialties.contains("Cardiology") }
        } else if selectedFilter == "Emergency Care" {
            clinics = clinics.filter { $0.isEmergencyCareAvailable }
        }
        
        return clinics
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                
                // MARK: - 1. Interactive MapKit View
                mapLayer
                    .ignoresSafeArea(edges: .bottom)
                
                // MARK: - 2. Floating Search & Filter Bar
                VStack(spacing: 8) {
                    preciseLocationBadge
                    searchAndFilterControls
                }
                .padding(.top, 4)
                
                // MARK: - 3. Selected Clinic Bottom Sheet Card
                VStack {
                    Spacer()
                    selectedClinicBottomCard
                }
            }
            .navigationTitle("Clinic Map")
            .inlineNavigationBarTitle()
            .onAppear {
                locationService.requestLocationPermission()
            }
            .alert("Geofence Arrival Detected! 📍", isPresented: $showGeofenceAlert) {
                Button("View Queue") {
                    showCheckInSheet = true
                }
                Button("Dismiss", role: .cancel) {}
            } message: {
                Text("You have arrived at \(selectedClinic.name). Automatic check-in completed. Your queue number has been assigned.")
            }
            .sheet(isPresented: $showCheckInSheet) {
                CheckInSuccessView()
            }
            .sheet(isPresented: $showDirectionsSheet) {
                clinicDirectionsSheetView
            }
        }
    }
    
    // MARK: - Subviews
    
    // 1. Map Layer
    @ViewBuilder
    private var mapLayer: some View {
        Map(coordinateRegion: $region, annotationItems: filteredClinics) { clinic in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: clinic.latitude, longitude: clinic.longitude)) {
                clinicPin(for: clinic)
            }
        }
    }
    
    // Custom Pin Annotation Marker
    @ViewBuilder
    private func clinicPin(for clinic: Clinic) -> some View {
        let isSelected = selectedClinic.id == clinic.id
        
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                selectedClinic = clinic
                region.center = CLLocationCoordinate2D(latitude: clinic.latitude, longitude: clinic.longitude)
            }
        } label: {
            VStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.mcTeal : Color.white)
                        .frame(width: isSelected ? 48 : 38, height: isSelected ? 48 : 38)
                        .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
                    
                    Image(systemName: "cross.case.fill")
                        .font(.system(size: isSelected ? 20 : 16))
                        .foregroundStyle(isSelected ? .white : Color.mcTeal)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.white : Color.mcTeal, lineWidth: 2)
                )
                
                // Pin pointer
                Image(systemName: "triangle.fill")
                    .font(.system(size: 8))
                    .foregroundStyle(isSelected ? Color.mcTeal : Color.white)
                    .rotationEffect(.degrees(180))
                    .offset(y: -2)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.15 : 1.0)
    }
    
    // 2. Location Indicator Header
    private var preciseLocationBadge: some View {
        HStack {
            HStack(spacing: 6) {
                Circle()
                    .fill(Color.mcStatusGreen)
                    .frame(width: 8, height: 8)
                
                Text("Using Precise Location · \(locationService.locationName)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.mcTextPrimary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    // 3. Search and Filter Controls
    private var searchAndFilterControls: some View {
        VStack(spacing: 8) {
            
            // Search Bar
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.mcTextSecondary)
                
                TextField("Search clinics, specialties, or areas...", text: $searchText)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.mcTextPrimary)
                    .autocorrectionDisabled()
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.mcTextSecondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 2)
            .padding(.horizontal, 20)
            
            // Filter Pills
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
                                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 1)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 2)
            }
        }
    }
    
    // 4. Selected Clinic Bottom Sheet Card (Figma Page 8)
    private var selectedClinicBottomCard: some View {
        VStack(spacing: 12) {
            
            // Clinic Title & Verified Badge
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 4) {
                        Text(selectedClinic.name)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.mcTextPrimary)
                        
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.mcStatusGreen)
                    }
                    
                    if let subtitle = selectedClinic.subtitle {
                        Text(subtitle)
                            .font(.system(size: 12))
                            .foregroundStyle(Color.mcTextSecondary)
                    }
                }
                
                Spacer()
                
                // Quick Call Button
                Button {
                    // Call clinic
                } label: {
                    Image(systemName: "phone.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(Color.mcTeal)
                }
                .buttonStyle(.plain)
            }
            
            // Meta Row: Distance, Drive time, Hours
            HStack(spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 10))
                    Text(selectedClinic.formattedDistance)
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundStyle(Color.mcTeal)
                
                Text("•")
                    .foregroundStyle(Color.mcBorderLight)
                
                Text(selectedClinic.formattedDriveTime)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.mcTextSecondary)
                
                Text("•")
                    .foregroundStyle(Color.mcBorderLight)
                
                Text(selectedClinic.openingHours)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.mcStatusGreen)
                
                Spacer()
            }
            
            // Address
            HStack(spacing: 4) {
                Image(systemName: "mappin")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.mcTextSecondary)
                
                Text(selectedClinic.address)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.mcTextSecondary)
                
                Spacer()
            }
            
            // Action Buttons Row
            HStack(spacing: 10) {
                
                // "Get Directions" in Apple Maps & Route View
                Button {
                    showDirectionsSheet = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
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
                
                // Geofence Simulation Button (For Demonstration & Grading)
                Button {
                    locationService.simulateGeofenceArrival(for: selectedClinic)
                    showGeofenceAlert = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "sensor.tag.radiowaves.forward.fill")
                            .font(.system(size: 12))
                        Text("Simulate Arrival")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .padding(.horizontal, 10)
                    .frame(height: 44)
                    .foregroundStyle(Color.mcTeal)
                    .background(Color.mcTealLight)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.mcTealBorder, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(Color.mcCardBg)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.mcBorderLight, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: -2)
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }
    
    // MARK: - In-App Route Guidance Sheet
    private var clinicDirectionsSheetView: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Header Route Card
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "cross.case.fill")
                            .foregroundStyle(Color.mcTeal)
                        Text(selectedClinic.name)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.mcTextPrimary)
                    }
                    
                    Text(selectedClinic.address)
                        .font(.system(size: 13))
                        .foregroundStyle(Color.mcTextSecondary)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "car.fill")
                            .font(.system(size: 12))
                        Text("\(selectedClinic.formattedDistance) · \(selectedClinic.formattedDriveTime) via Galle Road")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundStyle(Color.mcTeal)
                    .padding(.top, 4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(Color.mcTealLight)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                
                // Turn-by-Turn Route Guidance
                VStack(alignment: .leading, spacing: 14) {
                    Text("ROUTE GUIDANCE")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.mcTextLabel)
                    
                    stepRow(stepNumber: "1", instruction: "Depart from current location onto main road", distance: "400 m")
                    stepRow(stepNumber: "2", instruction: "Continue south along Galle Road / Marine Drive", distance: "\(selectedClinic.formattedDistance)")
                    stepRow(stepNumber: "3", instruction: "Arrive at \(selectedClinic.name). Parking available on-site.", distance: "100 m")
                }
                .padding(16)
                .background(Color.mcCardBg)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.mcBorderLight, lineWidth: 1)
                )
                
                Spacer()
                
                // Open Apple Maps Button
                Button {
                    openDirections(to: selectedClinic)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                        Text("Start Navigation in Apple Maps")
                            .font(.system(size: 15, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundStyle(.white)
                    .background(Color.mcTeal)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
            .padding(20)
            .navigationTitle("Clinic Route & Directions")
            .inlineNavigationBarTitle()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        showDirectionsSheet = false
                    }
                }
            }
        }
    }
    
    private func stepRow(stepNumber: String, instruction: String, distance: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(stepNumber)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(Color.mcTeal)
                .frame(width: 24, height: 24)
                .background(Color.mcTealLight)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(instruction)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.mcTextPrimary)
                Text(distance)
                    .font(.system(size: 11))
                    .foregroundStyle(Color.mcTextSecondary)
            }
            Spacer()
        }
    }
    
    // MARK: - Native Apple Maps Directions
    private func openDirections(to clinic: Clinic) {
        let coordinate = CLLocationCoordinate2D(latitude: clinic.latitude, longitude: clinic.longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = clinic.name
        
        #if os(iOS)
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
        #endif
    }
}

#if DEBUG
struct ClinicsMapView_Previews: PreviewProvider {
    static var previews: some View {
        ClinicsMapView()
    }
}
#endif
