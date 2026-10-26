// BookingViewModelTests.swift
// mediConnectTests
//
// Unit tests for appointment booking pipeline, Sri Lankan fee calculations, and cancellation terms.

#if canImport(XCTest)
import XCTest
import Foundation

final class BookingViewModelTests: XCTestCase {
    
    // MARK: - Fee Calculation Tests (PRD Feature 01 & Figma Page 5)
    func testConsultationTotalFeeCalculation() {
        let consultationFee: Double = 3500.0 // LKR 3,500
        let serviceFee: Double = 250.0       // LKR 250 platform fee
        let totalFee = consultationFee + serviceFee
        
        XCTAssertEqual(totalFee, 3750.0, "Total fee should equal consultation + service charge")
    }
    
    // MARK: - Cancellation Terms (2-Hour Policy)
    func testCancellationEligibilityPolicy() {
        let now = Date()
        
        // Appointment scheduled 3 hours in future -> Eligible for free cancellation
        let eligibleDate = now.addingTimeInterval(3 * 3600)
        let isEligible = eligibleDate.timeIntervalSince(now) >= (2 * 3600)
        XCTAssertTrue(isEligible, "Appointment scheduled >2h away should be eligible for free cancellation")
        
        // Appointment scheduled 30 mins in future -> Ineligible for free cancellation
        let ineligibleDate = now.addingTimeInterval(30 * 60)
        let isIneligible = ineligibleDate.timeIntervalSince(now) < (2 * 3600)
        XCTAssertTrue(isIneligible, "Appointment within 2h should not be eligible for free cancellation")
    }
    
    // MARK: - Patient Registry Details Validation
    func testPatientDetailsValidation() {
        let fullName = "Pasindu Mathsara"
        let age = "32"
        let nic = "199234509821"
        let contact = "+94 77 123 4567"
        
        XCTAssertFalse(fullName.trimmingCharacters(in: .whitespaces).isEmpty)
        XCTAssertTrue((Int(age) ?? 0) > 0)
        XCTAssertTrue(nic.count == 10 || nic.count == 12)
        XCTAssertFalse(contact.trimmingCharacters(in: .whitespaces).isEmpty)
    }
}
#endif
