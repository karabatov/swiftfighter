import Foundation
import Stockfighter

print("∴ Swiftfighter ∵")

var globalStop = false

let SF = SFAPI(baseAPI: "https://api.stockfighter.io/ob/api/", APIKey: "ho ho ho")

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

