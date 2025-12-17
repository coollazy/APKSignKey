import Foundation

public enum APKSignKeyError: Error, CustomStringConvertible, LocalizedError {
    case keyNotFound(path: String)
    case generateKeyFailed(reason: String)
    case invalidKeystore(path: String)
    case exportPublicKeyFailed(reason: String)
    
    public var description: String {
        switch self {
        case .keyNotFound(let path):
            return "Keystore file not found: \(path)"
        case .generateKeyFailed(let reason):
            return "Failed to generate keystore: \(reason)"
        case .invalidKeystore(let path):
            return "Invalid keystore or wrong password: \(path)"
        case .exportPublicKeyFailed(let reason):
            return "Failed to export public key: \(reason)"
        }
    }
    
    public var errorDescription: String? {
        description
    }
}
