import Foundation

protocol HealthDataProvider {
    func oxygenSaturationTrend() async -> [Observation]
}

struct MockHealthDataProvider: HealthDataProvider {
    func oxygenSaturationTrend() async -> [Observation] {
        (0..<14).map { idx in
            Observation(id: UUID().uuidString, kind: .oxygenSaturation, value: Double(93 + (idx % 4)), unit: "%", date: .now.addingTimeInterval(Double(-idx) * 86400))
        }
    }
}

struct HealthKitProviderPlaceholder: HealthDataProvider {
    func oxygenSaturationTrend() async -> [Observation] {
        await MockHealthDataProvider().oxygenSaturationTrend()
    }
}
