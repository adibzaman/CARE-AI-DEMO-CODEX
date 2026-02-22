import Foundation
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var demoModeEnabled = true
    @Published var consentAccepted = false
    @Published var connectedSystem = ""
    @Published var fakeTokenStored = false

    let keychain: KeychainStore
    let auditLogger: AuditLogger
    let fhirRepository: FHIRRepository
    let pghdStore: PGHDStore
    let healthProvider: HealthDataProvider

    init(
        keychain: KeychainStore = AppKeychainStore(),
        auditLogger: AuditLogger = AuditLogger(),
        fhirRepository: FHIRRepository = MockFHIRRepository(),
        pghdStore: PGHDStore = PGHDStore(),
        healthProvider: HealthDataProvider = MockHealthDataProvider()
    ) {
        self.keychain = keychain
        self.auditLogger = auditLogger
        self.fhirRepository = fhirRepository
        self.pghdStore = pghdStore
        self.healthProvider = healthProvider
    }

    func bootstrap() async {
        consentAccepted = UserDefaults.standard.bool(forKey: "consentAccepted")
        connectedSystem = UserDefaults.standard.string(forKey: "connectedSystem") ?? ""
        fakeTokenStored = (try? keychain.readToken()) != nil
    }

    func acceptConsent() {
        consentAccepted = true
        UserDefaults.standard.set(true, forKey: "consentAccepted")
        auditLogger.log("Consent accepted")
    }

    func connectDemoFHIR() async {
        connectedSystem = "Demo FHIR Server"
        UserDefaults.standard.set(connectedSystem, forKey: "connectedSystem")
        try? keychain.store(token: "demo-smart-token")
        fakeTokenStored = true
        auditLogger.log("Health system connected: Demo FHIR Server")
    }
}
