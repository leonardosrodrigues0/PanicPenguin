//
//  PlayerHealthComponent.swift
//  Penguin
//
//  Created by Erick Manaroulas Felipe on 26/01/22.
//

import GameplayKit

class PlayerHealthComponent: GKComponent {
    var gm = GameManager.shared

    var timeSinceLastHit: Double = 0
    
    func hit() {
        gm.speed.decrementSpeed()
        timeSinceLastHit = 0
    }

    override func didAddToEntity() {
        gm.playerHealth = self
    }

    override func update(deltaTime currentTime: TimeInterval) {
        if timeSinceLastHit == 0 {
            timeSinceLastHit = currentTime
        }

        let deltaTime = currentTime - timeSinceLastHit

        if deltaTime >= gm.currentSpeed.timeRequiredToIncrement {
            gm.speed.incrementSpeed()
            timeSinceLastHit = currentTime
        }
    }

    func die() {
        print("Player died.")
        GameManager.shared.state = .paused
    }
}
