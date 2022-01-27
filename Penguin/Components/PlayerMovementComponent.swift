//
//  PlayerMovementComponent.swift
//  Penguin
//
//  Created by Erick Manaroulas Felipe on 25/01/22.
//

import SceneKit
import GameplayKit
import CoreMotion

enum ControllerType {
    case motion
    case touch
    case none

    var dampemFactor: Float {
        switch self {
        case .motion:
            return 0.8
        case .touch:
            return 0.5
        case .none:
            return 0
        }
    }
}

class PlayerMovementComponent: GKComponent {

    var geometry: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }

    var controller = ControllerType.none

    override func didAddToEntity() {
        if entity?.component(ofType: MotionControllerComponent.self) != nil {
            controller = .motion
        } else if entity?.component(ofType: TouchControllerComponent.self) != nil {
            controller = .touch
        } else {
            controller = .none
        }
    }

    func move(by acceleration: Float, towards direction: Float) {
        guard let geometry = geometry,
              !geometry.node.hasActions else { return }

        let distance = Float(acceleration * controller.dampemFactor)

        // Motion reading minimum requirements
        guard acceleration > 0.15 || acceleration < -0.15 else { return }

        let newPosition = geometry.node.position + SCNVector3Make(distance * direction, 0, 0)

        // Make player respect bounds
        guard newPosition.x >= Config.minXPosition && newPosition.x <= Config.maxXPosition else { return }

        let moveAction = SCNAction.move(to: newPosition, duration: Config.interval)

        // Angle is passed in rads, so we convert it and divide by 2 to get about 15 at
        // max distance
        var spinDirection: CGFloat {
            switch controller {
            case .motion:
                return CGFloat(acceleration)
            case .touch:
                return CGFloat(direction)
            case .none:
                return CGFloat.zero
            }
        }

        let rotateAction = SCNAction.rotateBy(x: 0, y: spinDirection.toRad / 2, z: 0, duration: Config.interval)

        geometry.node.runAction(rotateAction)
        geometry.node.runAction(moveAction)
    }

}
