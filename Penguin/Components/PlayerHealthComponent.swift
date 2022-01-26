import GameplayKit

class PlayerHealthComponent: GKComponent {
    var gameManager = GameManager.shared

    var timeSinceLastHit: Double = 0
    
    func hit() {
        gameManager.speedManager.decrementSpeed()
        timeSinceLastHit = 0
    }

    override func didAddToEntity() {
        gameManager.playerHealth = self
    }

    override func update(deltaTime currentTime: TimeInterval) {
        if timeSinceLastHit == 0 {
            timeSinceLastHit = currentTime
        }

        let deltaTime = currentTime - timeSinceLastHit

        if deltaTime >= gameManager.currentSpeed.timeRequiredToIncrement {
            gameManager.speedManager.incrementSpeed()
            timeSinceLastHit = currentTime
        }
    }

    func die() {
        print("Player died.")
        GameManager.shared.state = .paused
    }
}
