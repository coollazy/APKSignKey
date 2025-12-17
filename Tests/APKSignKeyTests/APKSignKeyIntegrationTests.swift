import XCTest
@testable import APKSignKey

final class APKSignKeyIntegrationTests: XCTestCase {
    
    let keyAlias = "test-alias"
    let keyPassword = "password123"
    let storePassword = "storepassword123"
    let dname = "CN=Test User, OU=Test Unit, O=Test Org, L=Test City, ST=Test State, C=US"
    
    func testFullFlow() throws {
        // 1. Generate Key
        let key: APKSignKey
        do {
            key = try APKSignKey.generateKey(
                name: keyAlias,
                password: keyPassword,
                storePassword: storePassword,
                dname: dname
            )
            print("Generated Key at: \(key.url.path)")
        } catch {
            XCTFail("Failed to generate key: \(error)")
            return
        }
        
        // Ensure cleanup
        defer {
            try? FileManager.default.removeItem(at: key.url.deletingLastPathComponent())
        }
        
        // 2. Validate
        do {
            try key.validate()
        } catch {
            XCTFail("Validation failed: \(error)")
        }
        
        // 3. Get Info
        do {
            let info = try key.getKeyInfo()
            XCTAssertNotNil(info["creationDate"], "Should have creation date")
            XCTAssertNotNil(info["hasFingerprints"], "Should have fingerprints")
        } catch {
            XCTFail("Failed to get key info: \(error)")
        }
        
        // 4. Export Public Key
        let publicKeyURL = key.url.deletingLastPathComponent().appendingPathComponent("public.cer")
        do {
            try key.exportPublicKey(to: publicKeyURL)
            XCTAssertTrue(FileManager.default.fileExists(atPath: publicKeyURL.path))
        } catch {
            XCTFail("Failed to export public key: \(error)")
        }
    }
    
    @available(macOS 10.15.0, *)
    func testFullFlowAsync() async throws {
        // 1. Generate Key (Async)
        let key: APKSignKey
        do {
            key = try await APKSignKey.generateKey(
                name: keyAlias,
                password: keyPassword,
                storePassword: storePassword,
                dname: dname
            )
        } catch {
            XCTFail("Failed to generate key async: \(error)")
            return
        }
        
        // Ensure cleanup
        defer {
            try? FileManager.default.removeItem(at: key.url.deletingLastPathComponent())
        }
        
        // 2. Validate (Async)
        do {
            try await key.validate()
        } catch {
            XCTFail("Validation async failed: \(error)")
        }
        
        // 3. Get Info (Async)
        do {
            let info = try await key.getKeyInfo()
            XCTAssertNotNil(info["creationDate"], "Should have creation date")
            XCTAssertNotNil(info["hasFingerprints"], "Should have fingerprints")
        } catch {
            XCTFail("Failed to get key info async: \(error)")
        }
        
        // 4. Export Public Key (Async)
        let publicKeyURL = key.url.deletingLastPathComponent().appendingPathComponent("public_async.cer")
        do {
            try await key.exportPublicKey(to: publicKeyURL)
            XCTAssertTrue(FileManager.default.fileExists(atPath: publicKeyURL.path))
        } catch {
            XCTFail("Failed to export public key async: \(error)")
        }
    }
}
