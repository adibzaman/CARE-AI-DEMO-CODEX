import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        if !appState.consentAccepted {
            OnboardingView()
        } else if appState.connectedSystem.isEmpty {
            ConnectHealthSystemView()
        } else {
            HomeTabView()
        }
    }
}

struct DisclaimerBanner: View {
    var body: some View {
        Text("Not medical advice. For emergencies call 911.")
            .font(.footnote)
            .foregroundStyle(.white)
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(Color.red)
    }
}
