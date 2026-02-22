import Foundation

struct Patient: Codable, Identifiable {
    let id: String
    let name: String
    let birthDate: Date
}

struct Observation: Codable, Identifiable {
    enum Kind: String, Codable {
        case hemoglobin
        case reticulocyte
        case oxygenSaturation
        case bloodPressureSystolic
        case bloodPressureDiastolic
        case temperature
    }

    let id: String
    let kind: Kind
    let value: Double
    let unit: String
    let date: Date
}

struct Condition: Codable, Identifiable {
    let id: String
    let code: String
    let display: String
}

struct MedicationStatement: Codable, Identifiable {
    let id: String
    let medication: String
    let status: String
}

struct Encounter: Codable, Identifiable {
    let id: String
    let date: Date
    let type: String
}

struct FeverEntry: Codable, Identifiable {
    let id: UUID
    let date: Date
    let celsius: Double
}

struct SymptomEntry: Codable, Identifiable {
    let id: UUID
    let date: Date
    let hasChestSymptoms: Bool
}

struct AppAuditEvent: Codable, Identifiable {
    let id: UUID
    let date: Date
    let message: String
}

struct FHIRBundle: Codable {
    struct Entry: Codable {
        let resourceType: String
        let payload: String
    }

    let resourceType: String
    let type: String
    let timestamp: Date
    let entries: [Entry]

    init(timestamp: Date, entries: [Entry]) {
        self.resourceType = "Bundle"
        self.type = "collection"
        self.timestamp = timestamp
        self.entries = entries
    }
}
