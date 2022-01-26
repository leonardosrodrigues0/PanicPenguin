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
}

class GameManager: GKEntity {

    static let shared = GameManager()
    var speed = SpeedManagerComponent()
    var state: GameState = .paused
    var scene: GameScene?
    lazy var currentSpeed = speed.currentSpeed

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
