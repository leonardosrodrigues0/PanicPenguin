import SceneKit
import GameplayKit
import CoreMotion

class MotionControllerComponent: GKComponent {

    let motionManager = DeviceMotion.shared

    override func didAddToEntity() {
        motionManager?.startUpdates()
    }

    override func willRemoveFromEntity() {
        motionManager?.stopUpdates()
    }

    var player: PlayerMovementComponent? {
        return entity?.component(ofType: PlayerMovementComponent.self)
    }

    func acelerometer() {
        guard
            let player = player,
            let motion = motionManager?.motion
        else {
            return
        }

        motion.startAccelerometerUpdates(to: .main) { (data, error) in
            guard let data = data, error == nil else { return }

            let acceleration = data.acceleration.x
            let direction = acceleration

            player.move(by: Float(acceleration), towards: 1.0)
        }
    }

    override func update(deltaTime seconds: TimeInterval) {
        acelerometer()
    }
}
