import Foundation

enum Config {
    /// Base game time interval used in several stuff, in seconds
    static let interval: Double = 1 / 60

    /// Range of possible positions for the player in the X axis
    static let xMovementRange = -5.5 ... 5.5

    /// Base score added based on the distance
    static let baseScore: Double = 1
    /// Base coin score (increased according to the speed)
    static let baseCoinValue: Int = 20

    /// Maximum rotation angle of the player (in the edges), in degrees
    static let maxRotationAngle: Double = 15

    /// When using touch control, base distance traveled each tick
    static let touchMoveDistance: Double = 0.6

    enum Motion {
        /// Min angle that affects speed (dead zone), in degrees
        static let minAngle: Double = 3
        /// Max move distance in a tick, when the angle is maximum
        static let maxMoveDistance: Double = 0.8
        /// Max angle that affects speed, in degrees
        static let maxAngle: Double = 30
    }
}
