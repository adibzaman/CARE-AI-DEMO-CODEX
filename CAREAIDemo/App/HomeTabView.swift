import SwiftUI

struct HomeTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        TabView {
            SCDDashboardView(viewModel: SCDDashboardViewModel(fhir: appState.fhirRepository, healthProvider: appState.healthProvider, pghd: appState.pghdStore, audit: appState.auditLogger))
                .tabItem { Label("SCD", systemImage: "heart.text.square") }
            AorticDashboardView()
                .tabItem { Label("Aortic", systemImage: "waveform.path.ecg") }
            AICoachView()
                .tabItem { Label("Coach", systemImage: "message") }
            CommunityStubView()
                .tabItem { Label("Community", systemImage: "person.3") }
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}

struct CommunityStubView: View {
    var body: some View {
        VStack {
            DisclaimerBanner()
            Spacer()
            Text("Community features coming soon.")
            Spacer()
        }
    }
}
