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

        let newPosition = geometry.node.position + SCNVector3(0.0, 0.0, GameManager.shared.currentSpeed.speed)
        let moveAction = SCNAction.move(to: newPosition, duration: Config.interval)
        geometry.node.runAction(moveAction)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        move()
    }
    
}
