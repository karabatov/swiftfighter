import Stockfighter

print("∴ Swiftfighter ∵")

var stop = false

Heartbeat.isAPIup { ok in
    print("API is \(ok ? "up :)" : "down :(")")
    stop = true
}

repeat {} while !stop

