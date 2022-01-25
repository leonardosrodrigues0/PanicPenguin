
import SceneKit
import GameplayKit
import CoreMotion

class MotionControllerComponent: GKComponent {

    let motionManager = DeviceMotion.shared

    var geometry: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }

    override func didAddToEntity() {
        motionManager?.startUpdates()
    }

    override func willRemoveFromEntity() {
        motionManager?.stopUpdates()
    }

    func acelerometer() {
        guard let geometry = geometry,
              let motion = motionManager?.motion,
              !geometry.node.hasActions else { return }

        motion.startAccelerometerUpdates(to: .main) { (data, error) in
            guard let data = data, error == nil else { return }

            // TODO: Move movement code to Mover

            let acceleration = data.acceleration.x
            let dampemFactor = 2.0
            let distance = Float(acceleration / dampemFactor)

            // Motion reading minimum requirements
            guard acceleration > 0.15 || acceleration < -0.15 else { return }

            let newPosition = geometry.node.position + SCNVector3Make(distance, 0, 0)

            // Make player respect bounds
            guard newPosition.x >= -5.5 && newPosition.x <= 5.5 else { return }

            let moveAction = SCNAction.move(to: newPosition, duration: motion.accelerometerUpdateInterval)

            // Angle is passed in rads, so we convert it and divide by 2 to get about 15 at
            // max distance
            let rotateAction = SCNAction.rotateBy(x: 0, y: acceleration / 180 * .pi / 2, z: 0, duration: motion.accelerometerUpdateInterval)

            geometry.node.runAction(rotateAction)
            geometry.node.runAction(moveAction)
        }
    }

    override func update(deltaTime seconds: TimeInterval) {
        acelerometer()
    }
}
