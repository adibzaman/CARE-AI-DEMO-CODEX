import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let role: String
    let text: String
}

@MainActor
final class AICoachViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var input = ""
    @Published var shareVitals = true
    @Published var shareSymptoms = true

    var audit: AuditLogger?

    func send() async {
        guard !input.isEmpty else { return }
        let prompt = input
        messages.append(ChatMessage(role: "You", text: prompt))
        let response = "Demo Coach: Stay hydrated, follow your care plan, and contact your care team for worsening symptoms. Not medical advice. For emergencies call 911."
        messages.append(ChatMessage(role: "Coach", text: response))
        audit?.log("AI chat prompt: \(prompt)")
        audit?.log("AI chat response generated")
        input = ""
    }
}

struct AICoachView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var vm = AICoachViewModel()

    var body: some View {
        HStack {
            VStack {
                DisclaimerBanner()
                List(vm.messages) { msg in
                    Text("\(msg.role): \(msg.text)")
                }
                HStack {
                    TextField("Ask for coaching", text: $vm.input)
                        .textFieldStyle(.roundedBorder)
                    Button("Send") { Task { await vm.send() } }
                }.padding()
            }
            .onAppear { vm.audit = appState.auditLogger }

            VStack(alignment: .leading) {
                Text("Context Panel").font(.headline)
                Toggle("Share vitals", isOn: $vm.shareVitals)
                Toggle("Share symptoms", isOn: $vm.shareSymptoms)
                Spacer()
            }
            .padding()
            .frame(width: 220)
            .background(Color.gray.opacity(0.1))
        }
    }
}
