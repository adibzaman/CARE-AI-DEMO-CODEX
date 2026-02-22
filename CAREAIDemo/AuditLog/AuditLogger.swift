import Foundation
import Combine

@MainActor
final class AuditLogger: ObservableObject {
    @Published private(set) var events: [AppAuditEvent] = []

    func log(_ message: String) {
        events.append(AppAuditEvent(id: UUID(), date: Date(), message: message))
    }
}
