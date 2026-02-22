import Foundation

protocol AuthService {
    func startOAuthFlow() async throws -> String
}

struct MockSMARTAuthService: AuthService {
    func startOAuthFlow() async throws -> String {
        "demo-smart-token"
    }
}

struct RealSMARTAuthPlaceholder: AuthService {
    func startOAuthFlow() async throws -> String {
        throw URLError(.unsupportedURL)
    }
}
