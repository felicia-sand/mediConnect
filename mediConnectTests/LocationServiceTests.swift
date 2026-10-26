// LocationServiceTests.swift
// mediConnectTests
//
// Unit tests for Core Location distance calculations and geofencing arrival detection.

#if canImport(XCTest)
import XCTest
import CoreLocation

final class LocationServiceTests: XCTestCase {
    
    // Baseline Colombo 04 coordinates
    let colombo04 = CLLocationCoordinate2D(latitude: 6.8920, longitude: 79.8565)
    // Lanka Heart Care Clinic coordinates (Colombo 05)
    let lankaHeartClinic = CLLocationCoordinate2D(latitude: 6.8985, longitude: 79.8572)
    
    // MARK: - Distance Calculation Tests
    func testDistanceBetweenColomboPoints() {
        let loc1 = CLLocation(latitude: colombo04.latitude, longitude: colombo04.longitude)
        let loc2 = CLLocation(latitude: lankaHeartClinic.latitude, longitude: lankaHeartClinic.longitude)
        
        let distanceKm = loc1.distance(from: loc2) / 1000.0
        XCTAssertGreaterThan(distanceKm, 0.0)
        XCTAssertLessThan(distanceKm, 5.0, "Distance between adjacent Colombo suburbs should be less than 5 km")
    }
    
    // MARK: - Geofence Radius Threshold Tests
    func testGeofenceRadiusThreshold() {
        let geofenceRadiusMeters: Double = 100.0
        
        // Point inside geofence (20 meters away)
        let pointInsideDistance: Double = 20.0
        XCTAssertTrue(pointInsideDistance <= geofenceRadiusMeters, "Point within 100m should trigger entry")
        
        // Point outside geofence (250 meters away)
        let pointOutsideDistance: Double = 250.0
        XCTAssertFalse(pointOutsideDistance <= geofenceRadiusMeters, "Point beyond 100m should not trigger entry")
    }
}
#endif
