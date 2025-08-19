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
            ])
        }
        catch {
            throw APKSignKeyError.exportPublicKeyFailed(reason: error.localizedDescription)
        }
    }
}
