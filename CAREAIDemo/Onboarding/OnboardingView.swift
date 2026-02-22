import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var consentChecked = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("CARE-AI Demo")
                .font(.largeTitle).bold()
            Text("Demo eConsent: This prototype uses mocked data and does not provide diagnosis.")
            Toggle("I consent to participate in this app demo", isOn: $consentChecked)
            Button("Continue") {
                appState.acceptConsent()
            }
            .buttonStyle(.borderedProminent)
            .disabled(!consentChecked)
            Spacer()
        }
        .padding()
    }
}

struct ConnectHealthSystemView: View {
    @EnvironmentObject var appState: AppState

    let resources = ["Patient", "Observation", "Condition", "MedicationRequest", "MedicationStatement", "Goal", "Encounter", "DiagnosticReport", "Procedure"]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Connect Health System").font(.title2).bold()
            Button("Connect Demo FHIR Server") {
                Task { await appState.connectDemoFHIR() }
            }
            .buttonStyle(.borderedProminent)

            Text("Epic / Cerner / Generic").foregroundStyle(.secondary)
            Button("Coming soon") {}
                .disabled(true)

            Text("Supported resources")
                .font(.headline)
            ForEach(resources, id: \.self) { Text("• \($0)") }
            Spacer()
        }
        .padding()
    }
}
