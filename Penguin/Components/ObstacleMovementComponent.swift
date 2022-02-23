//
//  ObstacloMovementComponent.swift
//  Penguin
//
//  Created by Matheus Vicente on 26/01/22.
//

import Foundation
import GameplayKit
import SceneKit

class ObstacleMovementComponent: GKComponent {
    
    var geometry: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    func move() {
        guard
            let geometry = geometry,
            !geometry.node.hasActions
        else { return }

        let newPosition = geometry.node.position + SCNVector3(0.0, 0.0, Config.speedFactor * GameManager.shared.currentSpeed.rawValue)
        geometry.node.position = newPosition
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        move()
    }
    
}
