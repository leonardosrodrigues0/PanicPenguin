import SceneKit
import GameplayKit
import CoreMotion

struct MotionMovementManager: MovementManager {

    func getMove() -> Double? {
        guard let motionData = DeviceMotion.shared?.data else {
            return nil
        }

        let roll = motionData.attitude.roll
        return Self.moveDistance(deviceRoll: roll.toDegree)
    }

    func startUpdates() {
        DeviceMotion.shared?.startUpdates()
    }

    func stopUpdates() {
        DeviceMotion.shared?.stopUpdates()
    }

    /// Get move distance for a given device roll, in degrees.
    static private func moveDistance(deviceRoll: Double) -> Double {
        var absAngle = abs(deviceRoll)
        absAngle = absAngle >= Config.Motion.minAngle ? absAngle : 0
        absAngle = min(absAngle, Config.Motion.maxAngle)
        let absDistance = Config.Motion.maxMoveDistance * absAngle / Config.Motion.maxAngle
        let sign = deviceRoll / abs(deviceRoll)
        return sign * absDistance
    }
}
