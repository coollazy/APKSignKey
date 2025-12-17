import Foundation

// MARK: - 生成新密鑰
extension APKSignKey {
    public static func generateKey(name: String, password: String, storePassword: String, dname: String = "CN=Unknown,OU=Unknown,O=Unknown,L=Unknown,ST=Unknown,C=Unknown") throws -> APKSignKey {
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
                "-dname", dname,
            ], environment: ["LC_ALL": "C"])
        }
        catch {
            throw APKSignKeyError.generateKeyFailed(reason: error.localizedDescription)
        }
        
        return try APKSignKey(url: keyURL, name: name, password: password, storePassword: storePassword)
    }
    
    // 生成新密鑰 (Async)
    @available(macOS 10.15.0, *)
    public static func generateKey(name: String, password: String, storePassword: String, dname: String = "CN=Unknown,OU=Unknown,O=Unknown,L=Unknown,ST=Unknown,C=Unknown") async throws -> APKSignKey {
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
            _ = try await Command.run("keytool", arguments: [
                "-genkeypair",
                "-keystore", "\(keyURL.path)",
                "-keysize", "2048",
                "-alias", "\(name)",
                "-keyalg", "RSA",
                "-validity", "10000",
                "-keypass", "\(password)",
                "-storepass", "\(storePassword)",
                "-dname", dname,
            ], environment: ["LC_ALL": "C"])
        }
        catch {
            throw APKSignKeyError.generateKeyFailed(reason: error.localizedDescription)
        }
        
        // Use the synchronous initializer which performs a synchronous validate()
        // If validate() was also async, we would await it here.
        // For now, it will be sync.
        // TODO: Update once APKSignKey.init is async or validate() is async.
        return try APKSignKey(url: keyURL, name: name, password: password, storePassword: storePassword)
    }
}
