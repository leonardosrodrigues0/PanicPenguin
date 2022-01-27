import Foundation
import GameplayKit

class ScoreManagerComponent: GKComponent {

    var score: Int {
        Int(realScore)
    }

    private var realScore: Double = 0.0

    override func update(deltaTime seconds: TimeInterval) {
        let speedFactor = Double(GameManager.shared.currentSpeed.rawValue)
        realScore += Config.baseScore * speedFactor
    }

    func resetScore() {
        realScore = 0
    }

    func collectCoin() {
        print("coin collected")
        realScore += 10 
    }
}
