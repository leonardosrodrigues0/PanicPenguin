//
//  GameManager.swift
//  Penguin
//
//  Created by Erick Manaroulas Felipe on 26/01/22.
//

import GameplayKit
import SceneKit

enum GameState {
    case paused
    case playing
    case dead
}

protocol ManagerDelegate: NSObject {
    func didEnterDeathState()
}

class GameManager: GKEntity {

    static let shared = GameManager()

    var speed = SpeedManagerComponent()
    var state: GameState = .paused {
        didSet {
            if state == .dead {
                delegate?.didEnterDeathState()
            }
        }
    }
    lazy var currentSpeed = speed.currentSpeed

    var scene: GameScene?
    var delegate: ManagerDelegate?

    var playerHealth: PlayerHealthComponent? {
        didSet {
            speed.playerHealth = playerHealth
        }
    }

    override init() {
        super.init()
        addComponent(speed)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
