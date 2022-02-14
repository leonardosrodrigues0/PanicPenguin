import Foundation
import GameplayKit
import GameKit

class ScoreManagerComponent: GKComponent {

    var score: Int {
        Int(realScore)
    }

    private var realScore: Double = 0.0 {
        didSet {
            checkNewRecord(value: score) {
                print("Novo record: \(score)")
            }
        }
    }
    
    private var newRecord: Bool = false

    override func update(deltaTime seconds: TimeInterval) {
        realScore += Config.baseScore * GameManager.shared.currentSpeed.rawValue * seconds
    }

    func resetScore() {
        realScore = 0
        newRecord = false
    }

    func collectCoin() {
        realScore += Double(GameManager.shared.coinValue)
        print("collected \(GameManager.shared.coinValue) coins")
    }
    
    private func checkNewRecord(value: Int, completion: () -> Void) {
        guard GameCenterManager.shared.isAuthenticated else {
            return
        }
        
        if value > GameCenterManager.shared.highestScore && !newRecord {
            newRecord = true
            completion()
        }
    }
}
