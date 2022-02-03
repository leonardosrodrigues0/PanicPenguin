import GameplayKit

class PlayerHealthComponent: GKComponent {

    var timeSinceLastHit: Double = 0
    
    func hit() {
        GameManager.shared.speedManager.decrementSpeed()
        timeSinceLastHit = 0
    }

    override func didAddToEntity() {
        GameManager.shared.playerHealth = self
    }

    override func update(deltaTime currentTime: TimeInterval) {
        if timeSinceLastHit == 0 {
            timeSinceLastHit = currentTime
        }

        let deltaTime = currentTime - timeSinceLastHit

        if deltaTime >= GameManager.shared.currentSpeed.timeRequiredToIncrement {
            GameManager.shared.speedManager.incrementSpeed()
            timeSinceLastHit = currentTime
        }
    }

    func die() {
        print("Player died.")
        GameManager.shared.die()
    }
}
