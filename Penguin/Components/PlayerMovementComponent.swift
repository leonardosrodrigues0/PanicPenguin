import SceneKit
import GameplayKit
import CoreMotion

enum ControllerType {
    case motion
    case touch
    case none

    var dampenFactor: Float {
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
        guard
            let geometry = geometry,
            geometry.node.action(forKey: ActionType.move.rawValue) == nil,
            let animationComponent = entity?.component(ofType: AnimationComponent.self)
        else {
            return
        }

        let distance = Float(acceleration * controller.dampenFactor)

        // Motion reading minimum requirements
        guard acceleration > 0.15 || acceleration < -0.15 else { return }

        let deltaPosition = SCNVector3Make(distance * direction, 0, 0)
        let newPosition = geometry.node.position + deltaPosition

        // Make player respect bounds
        guard newPosition.x >= Config.minXPosition && newPosition.x <= Config.maxXPosition else { return }

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

        animationComponent.move(by: deltaPosition)
        animationComponent.rotate(by: spinDirection.toRad / 2)
    }

}
