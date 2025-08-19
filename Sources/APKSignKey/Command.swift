import Foundation

struct Command {
    @discardableResult
    static func run(_ command: String, arguments: [String]) throws -> String {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = [command] + arguments
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        try process.run()
        process.waitUntilExit()
        
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        
        let output = String(data: outputData, encoding: .utf8) ?? ""
        let error = String(data: errorData, encoding: .utf8) ?? ""
        let combinedOutput = output + error
        
        if process.terminationStatus != 0 {
            throw NSError(domain: "\(command) \(arguments.joined(separator: " "))\n\n\(output)\n\n\(error)", code: Int(process.terminationStatus))
        }
        
        return combinedOutput
    }
}
