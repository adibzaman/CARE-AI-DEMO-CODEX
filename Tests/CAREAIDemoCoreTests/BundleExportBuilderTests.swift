import XCTest
@testable import CAREAIDemoCore

final class BundleExportBuilderTests: XCTestCase {
    func testBuildIncludesPGHDFevers() {
        let obs = [Observation(id: "1", kind: .hemoglobin, value: 8.1, unit: "g/dL", date: .now)]
        let fever = [FeverEntry(id: UUID(), date: .now, celsius: 38.5)]
        let bundle = BundleExportBuilder().build(observations: obs, fevers: fever)

        XCTAssertEqual(bundle.resourceType, "Bundle")
        XCTAssertEqual(bundle.entries.count, 2)
        XCTAssertTrue(bundle.entries.contains { $0.payload.contains("temperature") })
    }
}
