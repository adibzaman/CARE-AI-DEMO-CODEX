import Foundation

enum SCDUrgencyStatus: Equatable {
    case urgent(String)
    case caution(String)
    case stable(String)
}

struct SCDDecisionSupport {
    func evaluate(latestFeverCelsius: Double?, latestSpO2: Double?, chestSymptoms: Bool) -> SCDUrgencyStatus {
        if (latestFeverCelsius ?? 0) >= 38.3 || (latestSpO2 ?? 100) < 92 || chestSymptoms {
            return .urgent("Fever ≥38.3°C in SCD is a medical emergency. Seek ED evaluation.")
        }
        if (latestFeverCelsius ?? 0) > 37.5 || (latestSpO2 ?? 100) < 95 {
            return .caution("Monitor symptoms closely and follow your care plan.")
        }
        return .stable("No urgent warning signs in current demo inputs.")
    }
}
