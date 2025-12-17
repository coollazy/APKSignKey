import XCTest
@testable import APKSignKey

final class APKSignKeyTests: XCTestCase {
    
    // 測試非同步指令執行
    func testCommandAsync() async throws {
        // 使用 echo 指令測試
        let output = try await Command.run("echo", arguments: ["Hello Async"])
        // echo 會輸出換行符號，所以要 trim
        XCTAssertEqual(output.trimmingCharacters(in: .whitespacesAndNewlines), "Hello Async")
    }
    
    // 測試同步指令執行
    func testCommandSync() throws {
        let output = try Command.run("echo", arguments: ["Hello Sync"])
        XCTAssertEqual(output.trimmingCharacters(in: .whitespacesAndNewlines), "Hello Sync")
    }
    
    // 測試環境變數傳遞
    func testCommandEnvironment() async throws {
        let output = try await Command.run("sh", arguments: ["-c", "echo $TEST_ENV"], environment: ["TEST_ENV": "EnvValue"])
        XCTAssertEqual(output.trimmingCharacters(in: .whitespacesAndNewlines), "EnvValue")
    }
    
    // 測試錯誤指令
    func testCommandFailure() async {
        do {
            _ = try await Command.run("ls", arguments: ["/non_existent_path"])
            XCTFail("Should throw error")
        } catch {
            // 預期錯誤
        }
    }
}
