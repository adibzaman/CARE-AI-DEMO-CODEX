import Foundation
import Combine

@MainActor
final class PGHDStore: ObservableObject {
    @Published var feverEntries: [FeverEntry] = []
    @Published var symptomEntries: [SymptomEntry] = []

    private let feverKey = "pghd.fever"
    private let symptomKey = "pghd.symptoms"

    init() { load() }

    func addFever(celsius: Double) {
        feverEntries.insert(FeverEntry(id: UUID(), date: .now, celsius: celsius), at: 0)
        save()
    }

    func setChestSymptoms(_ value: Bool) {
        symptomEntries.insert(SymptomEntry(id: UUID(), date: .now, hasChestSymptoms: value), at: 0)
        save()
    }

    var latestChestSymptoms: Bool { symptomEntries.first?.hasChestSymptoms ?? false }

    private func load() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: feverKey),
           let decoded = try? decoder.decode([FeverEntry].self, from: data) { feverEntries = decoded }
        if let data = UserDefaults.standard.data(forKey: symptomKey),
           let decoded = try? decoder.decode([SymptomEntry].self, from: data) { symptomEntries = decoded }
    }

    private func save() {
        let encoder = JSONEncoder()
        UserDefaults.standard.set(try? encoder.encode(feverEntries), forKey: feverKey)
        UserDefaults.standard.set(try? encoder.encode(symptomEntries), forKey: symptomKey)
    }
}
