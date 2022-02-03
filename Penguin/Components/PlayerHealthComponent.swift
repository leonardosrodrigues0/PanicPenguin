import GameplayKit

class PlayerHealthComponent: GKComponent {

    private var timeSinceLastHit: Double = 0
    
    func hit() {
        GameManager.shared.speedManager.decrementSpeed()
        timeSinceLastHit = 0
    }

    override func didAddToEntity() {
        GameManager.shared.playerHealth = self
    }

    override func update(deltaTime seconds: TimeInterval) {
        timeSinceLastHit += seconds

        if timeSinceLastHit >= GameManager.shared.currentSpeed.timeRequiredToIncrement {
            GameManager.shared.speedManager.incrementSpeed()
            timeSinceLastHit = 0
        }
    }
}
