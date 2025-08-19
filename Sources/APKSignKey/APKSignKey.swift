import Foundation

public class APKSignKey {
    public let url: URL
    public let name: String
    public let password: String
    public let storePassword: String
    
    public init(url: URL, name: String, password: String, storePassword: String) throws {
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw APKSignKeyError.keyNotFound(path: url.path)
        }
        self.url = url
        self.name = name
        self.password = password
        self.storePassword = storePassword
        
        try validate()
    }
    
    // 驗證密鑰庫
    public func validate() throws {
        do {
            try Command.run("keytool", arguments: [
                "-list",
                "-keystore", url.path,
                "-storepass", storePassword,
                "-alias", name
            ])
        }
        catch {
            throw APKSignKeyError.invalidKeystore(path: url.path)
        }
    }
    
    // 取得密鑰資訊
    public func getKeyInfo() throws -> [String: Any] {
        do {
            let output = try Command.run("keytool", arguments: [
                "-list",
                "-v",
                "-keystore", url.path,
                "-storepass", storePassword,
                "-alias", name
            ])
            
            // 解析輸出
            var info: [String: Any] = [:]
            let lines = output.components(separatedBy: .newlines)
            
            for line in lines {
                if line.contains("Creation date:") {
                    info["creationDate"] = line.replacingOccurrences(of: "Creation date: ", with: "").trimmingCharacters(in: .whitespaces)
                }
                else if line.contains("Certificate fingerprints:") {
                    info["hasFingerprints"] = true
                }
            }
            
            return info
        }
        catch {
            throw APKSignKeyError.invalidKeystore(path: url.path)
        }
    }
}
