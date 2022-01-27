//
//  SpeedManagerComponent.swift
//  Penguin
//
//  Created by Erick Manaroulas Felipe on 26/01/22.
//

import GameplayKit

enum Speed: Int {
    case v0
    case v1
    case v2
    case v3
    case v4
    case v5

    var timeRequiredToIncrement: Double {
        return 5
    }
}

class SpeedManagerComponent: GKComponent {
    var playerHealth: PlayerHealthComponent?

    private(set) var currentSpeed: Speed = .v2 {
        didSet {
            if currentSpeed == .v0 {
                playerHealth?.die()
            }
        }
    }

    func incrementSpeed() {
        if currentSpeed == .v4 { return }

        if let newSpeed = Speed(rawValue: currentSpeed.rawValue + 1) {
            currentSpeed = newSpeed
            print("accelerating to \(currentSpeed)")
        }
    }

    func decrementSpeed() {
        switch currentSpeed {
        case .v0:
            print("already dead")
        case .v1:
            currentSpeed = .v0
        case .v2:
            currentSpeed = .v1
        default:
            currentSpeed = .v2
        }
        print("decelerating to \(currentSpeed)")
    }

    func changeSpeed(to newSpeed: Speed) {
        currentSpeed = newSpeed
    }
}
