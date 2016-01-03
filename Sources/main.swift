import Foundation
import Stockfighter

print("∴ Swiftfighter ∵")

var globalStop = false

isStockfighterAPIup { heartbeat in
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

