import Foundation
import APKSignKey

let signKeyURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    .appendingPathComponent("Resources")
    .appendingPathComponent("test-signkey.jks")

let publicKeyURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    .appendingPathComponent("output")
    .appendingPathComponent("public.key")

do {
    // Load a existed sign key
    let existedSignKey = try APKSignKey(url: signKeyURL, name: "Temp", password: "123456", storePassword: "123456")
    print("Existed sign key => \(existedSignKey.url)")
    print("Existed sign key info => \n\(try existedSignKey.getKeyInfo())")
    
    print("\n=====================================\n")
    
    // Generate a new sign key
    let signKey = try APKSignKey.generateKey(name: "Temp", password: "123456", storePassword: "123456")
    print("New sign key => \(signKey.url)")
    print("New sign key info => \n\(try signKey.getKeyInfo())")
}
catch {
    print("APKBuilder error => \(error.localizedDescription)")
}
