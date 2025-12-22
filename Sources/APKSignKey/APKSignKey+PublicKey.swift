import Foundation

// MARK: - 匯出公鑰
extension APKSignKey {
    public func exportPublicKey(to outputURL: URL) throws {
        do {
            if FileManager.default.fileExists(atPath: outputURL.deletingLastPathComponent().path) == false {
                try FileManager.default.createDirectory(at: outputURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            }
            
            try Command.run("keytool", arguments: [
                "-exportcert",
                "-keystore", url.path,
                "-storepass", storePassword,
                "-alias", name,
                "-file", outputURL.path,
            ], environment: ["LC_ALL": "C"])
        }
        catch {
            throw APKSignKeyError.exportPublicKeyFailed(reason: error.localizedDescription)
        }
    }
    
    // 匯出公鑰 (Async)
    @available(macOS 10.15.0, *)
    public func exportPublicKey(to outputURL: URL) async throws {
        do {
            if FileManager.default.fileExists(atPath: outputURL.deletingLastPathComponent().path) == false {
                try FileManager.default.createDirectory(at: outputURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            }
            
            _ = try await Command.run("keytool", arguments: [
                "-exportcert",
                "-keystore", url.path,
                "-storepass", storePassword,
                "-alias", name,
                "-file", outputURL.path,
            ], environment: ["LC_ALL": "C"])
        }
        catch {
            throw APKSignKeyError.exportPublicKeyFailed(reason: error.localizedDescription)
        }
    }
}
