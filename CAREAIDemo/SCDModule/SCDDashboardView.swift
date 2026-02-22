import SwiftUI

struct SCDDashboardView: View {
    @StateObject var viewModel: SCDDashboardViewModel
    @State private var feverInput = "38.0"

    var body: some View {
        NavigationStack {
            ScrollView {
                DisclaimerBanner()
                statusCard
                VStack(alignment: .leading, spacing: 12) {
                    Text("Pain trend (14d)").font(.headline)
                    ForEach(0..<14, id: \.self) { idx in
                        HStack { Text("Day \(idx)").frame(width: 80, alignment: .leading); Rectangle().fill(.blue.opacity(0.4)).frame(width: Double((idx % 5) + 4) * 25, height: 8) }
                    }

                    Text("Fever log")
                    ForEach(viewModel.fevers) { entry in
                        Text("\(entry.date.formatted(date: .numeric, time: .shortened)) - \(entry.celsius, specifier: "%.1f")°C")
                    }
                    HStack {
                        TextField("38.3", text: $feverInput)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                        Button("Add Fever") {
                            if let value = Double(feverInput) { viewModel.addFever(value) }
                        }
                    }

                    Toggle("New chest symptoms", isOn: Binding(get: { viewModel.chestSymptoms }, set: { viewModel.setChestSymptoms($0) }))

                    Text("Acute care visits: \(viewModel.observations.count > 0 ? 2 : 0)")
                    Text("Latest Hb: \(viewModel.observations.first(where: { $0.kind == .hemoglobin })?.value ?? 0, specifier: "%.1f")")
                    Text("Latest retic: \(viewModel.observations.first(where: { $0.kind == .reticulocyte })?.value ?? 0, specifier: "%.1f")")
                }
                .padding()
            }
            .navigationTitle("SCD Dashboard")
            .task { await viewModel.load() }
        }
    }

    @ViewBuilder
    var statusCard: some View {
        switch viewModel.status {
        case .urgent(let text):
            Text(text).padding().frame(maxWidth: .infinity, alignment: .leading).background(Color.red.opacity(0.2)).padding(.horizontal)
        case .caution(let text):
            Text(text).padding().frame(maxWidth: .infinity, alignment: .leading).background(Color.yellow.opacity(0.2)).padding(.horizontal)
        case .stable(let text):
            Text(text).padding().frame(maxWidth: .infinity, alignment: .leading).background(Color.green.opacity(0.2)).padding(.horizontal)
        }
    }
}
