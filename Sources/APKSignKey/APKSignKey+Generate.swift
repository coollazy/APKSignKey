import Foundation

// MARK: - 生成新密鑰
extension APKSignKey {
    public static func generateKey(name: String, password: String, storePassword: String) throws -> APKSignKey {
        // 產生暫存路徑用來放新的SignKey
        let directoryURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("APKSignKey")
            .appendingPathComponent(UUID().uuidString)
        
        if FileManager.default.fileExists(atPath: directoryURL.path) == false {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        }
        let keyURL = directoryURL.appendingPathComponent("\(UUID().uuidString).jks")
        
        // 產生新的 SingKey
        do {
            try Command.run("keytool", arguments: [
                "-genkeypair",
                "-keystore", "\(keyURL.path)",
                "-keysize", "2048",
                "-alias", "\(name)",
                "-keyalg", "RSA",
                "-validity", "10000",
                "-keypass", "\(password)",
                "-storepass", "\(storePassword)",
                "-dname", "CN=YourName,OU=YourUnit,O=YourOrg,L=YourCity,ST=YourState,C=YourCountry",
            ])
        }
        catch {
            throw APKSignKeyError.generateKeyFailed(reason: error.localizedDescription)
        }
        
        return try APKSignKey(url: keyURL, name: name, password: password, storePassword: storePassword)
    }
}
