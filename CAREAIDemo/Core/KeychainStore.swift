import Foundation
#if canImport(Security)
import Security
#endif

protocol KeychainStore {
    func store(token: String) throws
    func readToken() throws -> String?
}

enum KeychainError: Error {
    case unexpectedStatus(OSStatus)
    case invalidEncoding
}

final class AppKeychainStore: KeychainStore {
    private let service = "CARE-AI-Demo"
    private let account = "oauth-token"
    private var memoryFallback: String?

    func store(token: String) throws {
#if canImport(Security)
        let data = Data(token.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
        var add = query
        add[kSecValueData as String] = data
        let status = SecItemAdd(add as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.unexpectedStatus(status) }
#else
        memoryFallback = token
#endif
    }

    func readToken() throws -> String? {
#if canImport(Security)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecItemNotFound { return nil }
        guard status == errSecSuccess else { throw KeychainError.unexpectedStatus(status) }
        guard let data = item as? Data, let token = String(data: data, encoding: .utf8) else {
            throw KeychainError.invalidEncoding
        }
        return token
#else
        return memoryFallback
#endif
    }
}
