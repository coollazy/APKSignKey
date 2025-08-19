import Foundation

public enum APKSignKeyError: Error, CustomStringConvertible, LocalizedError {
    case keyNotFound(path: String)
    case generateKeyFailed(reason: String)
    case invalidKeystore(path: String)
    case exportPublicKeyFailed(reason: String)
    
    public var description: String {
        switch self {
        case .keyNotFound(let path):
            return "密鑰檔案不存在: \(path)"
        case .generateKeyFailed(let reason):
            return "生成密鑰失敗: \(reason)"
        case .invalidKeystore(let path):
            return "無效的密鑰庫: \(path)"
        case .exportPublicKeyFailed(let reason):
            return "匯出公鑰失敗: \(reason)"
        }
    }
    
    public var errorDescription: String? {
        description
    }
}
