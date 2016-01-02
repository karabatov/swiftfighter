import Stockfighter

print("∴ Swiftfighter ∵")

var stop = false

Heartbeat.isAPIup { up in
    print("API is \(up ? "up :)" : "down :(")")
    stop = true
}

repeat {} while !stop

