import Foundation
import Stockfighter

print("∴ Swiftfighter ∵")

/// SF API instance.
let SF: SFAPI
/// API key string, read from file during program start.
var apiKey = ""
/// Desired level to start, first by default.
var levelPlayed = StockfighterLevel.FirstSteps
/// Current game.
var game: Game?

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

SF.isAPIUp { heartbeat in
    if heartbeat.ok {
        print("API is up!")

        game = Game(SF: SF, level: levelPlayed)
        game?.startGame()
    } else {
        print("API is down: \(heartbeat.error)")
    }
}

// Readline doesn't eat any cycles while the game is running. Otherwise multithreading doesn't work!
repeat {} while readLine() != "~"

// A little dance to stop the level instance before quitting, if possible.
var stop = true
if let game = game {
    stop = false
    print("Stopping level instance…")
    game.stopGame { stopped in
        print("Level instance stopped: \(stopped)")
        stop = true
    }
}
repeat {} while !stop
