import Foundation
import Stockfighter

print("∴ Swiftfighter ∵")

/// Global stop flag, program is running only while it's false.
var globalStop = false
/// API key string, read from file during program start.
var apiKey = ""
/// Desired level to start, first by default.
var levelPlayed = StockfighterLevel.FirstSteps

// MARK: Command line arguments

switch Process.arguments.count {
case 3:
    if let
        fileData = NSFileManager.defaultManager().contentsAtPath(Process.arguments[1]),
        apiKeyStr = String(data: fileData, encoding: NSUTF8StringEncoding),
        levelNumber = Int(Process.arguments[2]),
        level = StockfighterLevel(rawValue: levelNumber)
    {
        levelPlayed = level
        apiKey = apiKeyStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
default:
    print("Usage:")
    print("$ Swiftfighter api_key.txt level_number")
    fatalError("Wrong command line parameters given.")
}

let SF = SFAPI(baseAPI: "https://api.stockfighter.io", APIKey: apiKey)

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

