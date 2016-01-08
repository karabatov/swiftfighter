import Foundation
import Stockfighter

print("∴ Swiftfighter ∵")

/// Global stop flag, program is running only while it's false.
var globalStop = false
/// SF API instance.
var SF: SFAPI?
/// API key string, read from file during program start.
var apiKey = ""
/// Desired level to start, first by default.
var levelPlayed = StockfighterLevel.FirstSteps
/// Status of the running level instance.
var instanceStatus: InstanceStatus? {
    didSet {
        guard let status = instanceStatus else { return }
        print("Instance \(status.instance) on day \(status.tradingDay) of \(status.totalDays), done: \(status.done).")
    }
}
func performInstanceHealthcheck(SF: SFAPI?, levelInstance: InstanceId) {
    // Start a healthcheck on the level.
    SF?.getStateForLevelInstance(levelInstance) { newInstanceStatus in
        // TODO: Make sure new status is newer than old status.
        instanceStatus = newInstanceStatus

        performInstanceHealthcheck(SF, levelInstance: levelInstance)
    }
}

/// Running level instance, if any.
var levelInstance: InstanceId = 0 {
    didSet {
        guard levelInstance > 0 else { return }

        performInstanceHealthcheck(SF, levelInstance: levelInstance)
    }
}

/// Running level info.
var runningLevel: Level? {
    didSet {
        guard let level = runningLevel else { return }

        levelInstance = level.instance
        print(level.account)
        print(level.instance)
        print(level.instructions)
        print(level.secondsPerDay)
        print(level.tickers)
        print(level.venues)
        print(level.balances)
    }
}

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

SF = SFAPI(baseAPI: "https://api.stockfighter.io", APIKey: apiKey)

SF?.isAPIUp { heartbeat in
    if heartbeat.ok {
        print("API is up!")

        SF?.startLevel(levelPlayed) { newLevel in
            runningLevel = newLevel
        }
    } else {
        print("API is down: \(heartbeat.error)")
        globalStop = true
    }
}

repeat {} while !globalStop

