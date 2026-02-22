import XCTest
@testable import CAREAIDemoCore

final class SCDDecisionSupportTests: XCTestCase {
    func testUrgentWhenFeverHigh() {
        let status = SCDDecisionSupport().evaluate(latestFeverCelsius: 38.3, latestSpO2: 98, chestSymptoms: false)
        XCTAssertEqual(status, .urgent("Fever ≥38.3°C in SCD is a medical emergency. Seek ED evaluation."))
    }

    func testUrgentWhenLowSpO2() {
        let status = SCDDecisionSupport().evaluate(latestFeverCelsius: 37, latestSpO2: 90, chestSymptoms: false)
        XCTAssertEqual(status, .urgent("Fever ≥38.3°C in SCD is a medical emergency. Seek ED evaluation."))
    }
}
