import Foundation

struct Command {
    @discardableResult
    static func run(_ command: String, arguments: [String]) throws -> String {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<String, Error>?
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = [command] + arguments
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        // 設定完成回調(Docker container 裡面運行的時候，一定要用 terminatinHandler 才不會卡住)
        process.terminationHandler = { process in
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            
            let output = String(data: outputData, encoding: .utf8) ?? ""
            let error = String(data: errorData, encoding: .utf8) ?? ""
            let combinedOutput = output + error
            
            if process.terminationStatus == 0 {
                result = .success(combinedOutput)
            }
            else {
                let error = NSError(
                    domain: "Command Error \(command)",
                    code: Int(process.terminationStatus),
                    userInfo: [NSLocalizedDescriptionKey: "\(arguments.joined(separator: " "))\n\n\(output)\n\n\(error)"]
                )
                result = .failure(error)
            }
            semaphore.signal()
        }
        
        do {
            try process.run()
            let timeoutResult = semaphore.wait(timeout: .now() + 5)
            if timeoutResult == .timedOut {
                process.terminate()
                throw NSError(
                    domain: "Command Timeout Error",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "\(command) operation timed out"]
                )
            }
        } catch {
            result = .failure(error)
        }
        
        guard let result else {
            throw NSError(
                domain: "Command Error \(command)",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "\(command) operation failed, no result"]
            )
        }
        switch result {
        case .success(let output):
            return output
        case .failure(let error):
            throw error
        }
    }
}
