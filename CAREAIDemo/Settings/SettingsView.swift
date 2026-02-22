import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingExport = false
    @State private var exportJSON = ""
    @State private var showingAudit = false

    var body: some View {
        NavigationStack {
            List {
                Toggle("Demo Mode", isOn: $appState.demoModeEnabled)
                Button("Export My Data") {
                    Task {
                        let observations = await appState.fhirRepository.observations()
                        let bundle = BundleExportBuilder().build(observations: observations, fevers: appState.pghdStore.feverEntries)
                        exportJSON = BundleExportBuilder().json(bundle: bundle)
                        appState.auditLogger.log("Export generated")
                        showingExport = true
                    }
                }
                Button("View Audit Log") { showingAudit = true }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingExport) {
                NavigationStack {
                    ScrollView { Text(exportJSON).font(.system(.footnote, design: .monospaced)).padding() }
                        .navigationTitle("FHIR Bundle Preview")
                }
            }
            .sheet(isPresented: $showingAudit) {
                AuditLogView()
                    .environmentObject(appState)
            }
        }
    }
}

struct AuditLogView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            List(appState.auditLogger.events.sorted { $0.date > $1.date }) { event in
                VStack(alignment: .leading) {
                    Text(event.message)
                    Text(event.date.formatted(date: .numeric, time: .standard))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Audit Log")
        }
    }
}
