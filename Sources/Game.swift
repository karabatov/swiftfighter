import Foundation
import Stockfighter
/// Starting and playing a game level. main.swift is not very good at this.
class Game: NSObject {
    private let SF: SFAPI
    private let levelName: StockfighterLevel

    private var instance: InstanceId = 0
    private var instanceStatus: InstanceStatus?
    private var level: Level?
    private var healThread = NSThread()

    init(SF: SFAPI, level levelName: StockfighterLevel) {
        self.SF = SF
        self.levelName = levelName
    }

    func startGame() {
        SF.startLevel(levelName) { newLevel in
            self.level = newLevel
            Game.printLevelInfo(newLevel)

            self.instance = newLevel.instance
            self.healThread = NSThread(target: self, selector: "instanceHealthCheck", object: nil)
            self.healThread.start()
        }
    }

    /// Called by self.healThread, so can't be private.
    func instanceHealthCheck() {
        guard instance > 0 else { return }

        SF.getStateForLevelInstance(instance) { newInstanceStatus in
            self.instanceStatus = newInstanceStatus
            Game.printInstanceStatus(newInstanceStatus)

            NSThread.sleepForTimeInterval(5.0)
            self.instanceHealthCheck()
        }
    }
}

// MARK: Pretty printing

extension Game {
    class func printLevelInfo(level: Level) {
        print(level.account)
        print(level.instance)
        print(level.instructions)
        print(level.secondsPerDay)
        print(level.tickers)
        print(level.venues)
        print(level.balances)
    }

    class func printInstanceStatus(status: InstanceStatus) {
        print("Instance \(status.instance) on day \(status.tradingDay) of \(status.totalDays), done: \(status.done).")
    }
}
