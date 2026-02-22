import Foundation

protocol FHIRRepository {
    func patient() async -> Patient
    func observations() async -> [Observation]
    func conditions() async -> [Condition]
    func medicationStatements() async -> [MedicationStatement]
    func encounters() async -> [Encounter]
}

struct MockFHIRRepository: FHIRRepository {
    func patient() async -> Patient {
        Patient(id: "demo-patient", name: "Taylor Demo", birthDate: .now.addingTimeInterval(-946080000))
    }

    func observations() async -> [Observation] {
        let cal = Calendar.current
        return (0..<14).map { day in
            Observation(id: UUID().uuidString, kind: .hemoglobin, value: 8.2 + Double(day % 3) * 0.3, unit: "g/dL", date: cal.date(byAdding: .day, value: -day, to: .now) ?? .now)
        } + [
            Observation(id: UUID().uuidString, kind: .reticulocyte, value: 8.3, unit: "%", date: .now.addingTimeInterval(-86400)),
            Observation(id: UUID().uuidString, kind: .oxygenSaturation, value: 95, unit: "%", date: .now),
            Observation(id: UUID().uuidString, kind: .bloodPressureSystolic, value: 122, unit: "mmHg", date: .now)
        ]
    }

    func conditions() async -> [Condition] {
        [Condition(id: "1", code: "D57.1", display: "Sickle-cell disease")]
    }

    func medicationStatements() async -> [MedicationStatement] {
        [MedicationStatement(id: "m1", medication: "Hydroxyurea", status: "active")]
    }

    func encounters() async -> [Encounter] {
        [Encounter(id: "e1", date: .now.addingTimeInterval(-40_000), type: "ED"), Encounter(id: "e2", date: .now.addingTimeInterval(-400_000), type: "Urgent Care")]
    }
}

struct RealFHIRRepositoryPlaceholder: FHIRRepository {
    func patient() async -> Patient { await MockFHIRRepository().patient() }
    func observations() async -> [Observation] { await MockFHIRRepository().observations() }
    func conditions() async -> [Condition] { await MockFHIRRepository().conditions() }
    func medicationStatements() async -> [MedicationStatement] { await MockFHIRRepository().medicationStatements() }
    func encounters() async -> [Encounter] { await MockFHIRRepository().encounters() }
}
