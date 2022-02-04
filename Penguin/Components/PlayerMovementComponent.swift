import SceneKit
import GameplayKit
import CoreMotion

class PlayerMovementComponent: GKComponent {

    var geometry: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }

    var controllerType: MovementManagerType? {
        didSet {
            movementManager = controllerType?.newManager
        }
    }

    private(set) var movementManager: MovementManager? {
        didSet {
            movementManager?.startUpdates()
        }

        willSet {
            movementManager?.stopUpdates()
        }
    }

    override func didAddToEntity() {
        GameManager.shared.playerMovement = self
    }

    func move(by distance: Double) {
        guard
            let geometry = geometry,
            geometry.node.action(forKey: ActionType.move.rawValue) == nil,
            let animationComponent = entity?.component(ofType: AnimationComponent.self)
        else {
            return
        }

        let deltaPosition = SCNVector3(distance, 0, 0)
        let newPosition = geometry.node.position + deltaPosition

        guard Config.xMovementRange.contains(Double(newPosition.x)) else { return }

        let rotationAngle = 2 * Config.maxRotationAngle * distance / Config.xMovementRange.size

        animationComponent.move(by: deltaPosition)
        animationComponent.rotate(by: CGFloat(rotationAngle.toRad))
    }

    override func update(deltaTime seconds: TimeInterval) {
        if let moveDistance = movementManager?.getMove() {
            move(by: moveDistance)
        }
    }
}
