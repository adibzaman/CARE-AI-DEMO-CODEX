import SwiftUI

struct AorticDashboardView: View {
    @State private var adherence = Array(repeating: false, count: 7)

    var body: some View {
        ScrollView {
            DisclaimerBanner()
            VStack(alignment: .leading, spacing: 14) {
                Text("BP Trend").font(.headline)
                ForEach(0..<7, id: \.self) { idx in
                    HStack { Text("Day \(idx + 1)").frame(width: 80, alignment: .leading); Rectangle().fill(.green.opacity(0.4)).frame(width: Double(118 + idx - 100) * 3, height: 8) }
                }

                Text("Imaging Timeline").font(.headline)
                Text("• 2023-02 Echo: stable")
                Text("• 2024-01 CTA: mild dilation")

                Text("Meds adherence").font(.headline)
                ForEach(0..<7, id: \.self) { idx in
                    Toggle("Day \(idx + 1)", isOn: $adherence[idx])
                }
            }
            .padding()
        }
    }
}
