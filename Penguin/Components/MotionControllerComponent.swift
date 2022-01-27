import SceneKit
import GameplayKit
import CoreMotion

class MotionControllerComponent: GKComponent {

    override func didAddToEntity() {
        DeviceMotion.shared?.startUpdates()
    }

    override func willRemoveFromEntity() {
        DeviceMotion.shared?.stopUpdates()
    }

    var player: PlayerMovementComponent? {
        return entity?.component(ofType: PlayerMovementComponent.self)
    }

    private func accelerometer() {
        guard
            let player = player,
            let motion = DeviceMotion.shared?.motion
        else {
            return
        }

        motion.startAccelerometerUpdates(to: .main) { (data, error) in
            guard let data = data, error == nil else { return }

            let acceleration = data.acceleration.x

            player.move(by: Float(acceleration), towards: 1.0)
        }
    }

    override func update(deltaTime seconds: TimeInterval) {
        accelerometer()
    }
}
