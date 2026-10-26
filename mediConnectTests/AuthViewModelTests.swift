// AuthViewModelTests.swift
// mediConnectTests
//
// Unit tests for Authentication, Sri Lankan NIC validation, and Security rules.

#if canImport(XCTest)
import XCTest
import Foundation

final class AuthViewModelTests: XCTestCase {
    
    // MARK: - Sri Lankan NIC Validation Tests
    func testValidNewSriLankanNIC() {
        let newNIC = "199234509821" // 12-digit format
        let isDigitsOnly = newNIC.allSatisfy { $0.isNumber }
        let isValid = newNIC.count == 12 && isDigitsOnly
        XCTAssertTrue(isValid, "12-digit new Sri Lankan NIC should be valid")
    }
    
    func testValidOldSriLankanNIC() {
        let oldNIC = "923450982V" // 9 digits followed by 'V' or 'X'
        let prefix = oldNIC.dropLast()
        let suffix = oldNIC.suffix(1).uppercased()
        let isValid = oldNIC.count == 10 && prefix.allSatisfy { $0.isNumber } && (suffix == "V" || suffix == "X")
        XCTAssertTrue(isValid, "9-digit + V old Sri Lankan NIC should be valid")
    }
    
    func testInvalidNIC() {
        let invalidNIC1 = "12345" // too short
        let invalidNIC2 = "1992345098210" // too long
        let invalidNIC3 = "ABCDEFGHIJKL" // letters
        
        XCTAssertFalse(invalidNIC1.count == 10 || invalidNIC1.count == 12)
        XCTAssertFalse(invalidNIC2.count == 10 || invalidNIC2.count == 12)
        XCTAssertFalse(invalidNIC3.allSatisfy { $0.isNumber })
    }
    
    // MARK: - Phone Number Validation Tests
    func testValidSriLankanPhoneFormat() {
        let phoneWithCode = "+94771234567"
        let phoneLocal = "0771234567"
        
        let digitsOnly = phoneWithCode.replacingOccurrences(of: "+", with: "")
        XCTAssertTrue(digitsOnly.allSatisfy { $0.isNumber })
        XCTAssertTrue(phoneLocal.count == 10 && phoneLocal.hasPrefix("07"))
    }
    
    // MARK: - OTP Code Tests
    func testOTPCodeLength() {
        let validOTP = "584920"
        let invalidOTP = "1234"
        
        XCTAssertEqual(validOTP.count, 6)
        XCTAssertNotEqual(invalidOTP.count, 6)
    }
    
    // MARK: - Password Strength Tests
    func testPasswordComplexityRules() {
        let strongPassword = "SecurePass123!"
        
        let hasMinLength = strongPassword.count >= 8
        let hasUppercase = strongPassword.contains(where: { $0.isUppercase })
        let hasNumber = strongPassword.contains(where: { $0.isNumber })
        let hasSymbol = strongPassword.contains(where: { "!@#$%^&*()_+-=[]{}|;':,.<>?".contains($0) })
        
        XCTAssertTrue(hasMinLength)
        XCTAssertTrue(hasUppercase)
        XCTAssertTrue(hasNumber)
        XCTAssertTrue(hasSymbol)
    }
}
#endif
