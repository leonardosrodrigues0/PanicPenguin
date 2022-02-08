import Foundation
import GameplayKit

class ScoreManagerComponent: GKComponent {

    var score: Int {
        Int(realScore)
    }

    private var realScore: Double = 0.0

    override func update(deltaTime seconds: TimeInterval) {
        realScore += Config.baseScore * GameManager.shared.currentSpeed.rawValue * seconds
    }

    func resetScore() {
        realScore = 0
    }

    func collectCoin() {
        realScore += Double(GameManager.shared.coinValue)
        print("collected \(GameManager.shared.coinValue) coins")
    }
}
