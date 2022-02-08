import CoreMotion

class DeviceMotion {
    static let shared = DeviceMotion()

    private let motion = CMMotionManager()
    var data: CMDeviceMotion? {
        motion.deviceMotion
    }

    private init?() {
        if !motion.isDeviceMotionAvailable {
            print("Device Motion not available")
            return nil
        }

        motion.deviceMotionUpdateInterval = Config.interval
    }

    func startUpdates() {
        if !motion.isDeviceMotionActive {
            motion.startDeviceMotionUpdates()
        }
    }

    func stopUpdates() {
        if motion.isDeviceMotionActive {
            motion.stopDeviceMotionUpdates()
        }
    }
}
