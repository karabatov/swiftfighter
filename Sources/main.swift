import Foundation
import Stockfighter

print("∴ Swiftfighter ∵")

/// Global stop flag, program is running only while it's false.
var globalStop = false
/// API key string, read from file during program start.
var apiKey = ""

// MARK: Command line arguments

switch Process.arguments.count {
case 1:
    print("Usage:")
    print("$ Swiftfighter api_key.txt")
    fatalError()
case 2:
    if let
        fileData = NSFileManager.defaultManager().contentsAtPath(Process.arguments[1]),
        apiKeyStr = String(data: fileData, encoding: NSUTF8StringEncoding)
    {
        apiKey = apiKeyStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    } else {
        fatalError()
    }
default:
    break
}

let SF = SFAPI(baseAPI: "https://api.stockfighter.io/ob/api/", APIKey: apiKey)

SF.isAPIUp { heartbeat in
    if heartbeat.ok {
        print("API is up!")
    } else {
        print("API is down: \(heartbeat.error)")
        globalStop = true
    }
}

repeat {
    NSThread.sleepForTimeInterval(1.0)
} while !globalStop

