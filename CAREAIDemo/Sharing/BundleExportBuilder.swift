import Foundation

struct BundleExportBuilder {
    func build(observations: [Observation], fevers: [FeverEntry]) -> FHIRBundle {
        let obsEntries = observations.map {
            FHIRBundle.Entry(resourceType: "Observation", payload: "\($0.kind.rawValue): \($0.value) \($0.unit)")
        }
        let feverEntries = fevers.map {
            FHIRBundle.Entry(resourceType: "Observation", payload: "temperature: \($0.celsius) C")
        }
        return FHIRBundle(timestamp: .now, entries: obsEntries + feverEntries)
    }

    func json(bundle: FHIRBundle) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let data = (try? encoder.encode(bundle)) ?? Data()
        return String(data: data, encoding: .utf8) ?? "{}"
    }
}
