import Foundation
import Combine

@MainActor
final class SCDDashboardViewModel: ObservableObject {
    @Published var observations: [Observation] = []
    @Published var fevers: [FeverEntry] = []
    @Published var chestSymptoms = false
    @Published var status: SCDUrgencyStatus = .stable("Loading")

    private let fhir: FHIRRepository
    private let healthProvider: HealthDataProvider
    private let pghd: PGHDStore
    private let support = SCDDecisionSupport()
    private let audit: AuditLogger

    init(fhir: FHIRRepository, healthProvider: HealthDataProvider, pghd: PGHDStore, audit: AuditLogger) {
        self.fhir = fhir
        self.healthProvider = healthProvider
        self.pghd = pghd
        self.audit = audit
    }

    func load() async {
        observations = await fhir.observations() + (await healthProvider.oxygenSaturationTrend())
        fevers = pghd.feverEntries
        chestSymptoms = pghd.latestChestSymptoms
        recompute()
        audit.log("SCD dashboard viewed")
    }

    func addFever(_ value: Double) {
        pghd.addFever(celsius: value)
        fevers = pghd.feverEntries
        recompute()
    }

    func setChestSymptoms(_ value: Bool) {
        pghd.setChestSymptoms(value)
        chestSymptoms = value
        recompute()
    }

    private func recompute() {
        let spo2 = observations.filter { $0.kind == .oxygenSaturation }.sorted { $0.date > $1.date }.first?.value
        let fever = fevers.first?.celsius
        status = support.evaluate(latestFeverCelsius: fever, latestSpO2: spo2, chestSymptoms: chestSymptoms)
    }
}
