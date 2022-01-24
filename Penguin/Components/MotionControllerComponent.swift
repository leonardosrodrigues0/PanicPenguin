
import SceneKit
import GameplayKit
import CoreMotion

class MotionControllerComponent: GKComponent {

    // TODO: Start using DeviceMotion
    let motionManager = CMMotionManager()

    var geometry: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }

    func acelerometer(deltaTime seconds: TimeInterval) {
        guard let geometry = geometry, motionManager.isAccelerometerAvailable else { return }
        // TODO: make minimum motion requirement for movement

        motionManager.accelerometerUpdateInterval = 0.01
        motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
            guard let data = data, error == nil, !geometry.node.hasActions else {
                return
            }
            let moveAction = SCNAction.moveBy(x: CGFloat(data.acceleration.x), y: 0, z: 0, duration: self.motionManager.accelerometerUpdateInterval)
            // TODO: make character respect bounds
            // TODO: try to make animation smoother

            geometry.node.runAction(moveAction)
        }
    }

    override func update(deltaTime seconds: TimeInterval) {
        acelerometer(deltaTime: seconds)
    }
}
