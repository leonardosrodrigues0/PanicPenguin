import GameplayKit

enum Speed: Int {
    case v0
    case v1
    case v2
    case v3
    case v4
    case v5

    var speed: Double {
        switch self {
        case .v0:
            return 1.0
        case .v1:
            return 1.0
        case .v2:
            return 1.5
        case .v3:
            return 2.0
        case .v4:
            return 2.5
        case .v5:
            return 3.0
        }
    }

    var timeRequiredToIncrement: Double {
        switch self {
        case .v0:
            return 3.0
        case .v1:
            return 3.0
        case .v2:
            return 5.0
        case .v3:
            return 7.0
        case .v4:
            return 10.0
        case .v5:
            return 1.0
        }
    }
}

class SpeedManagerComponent: GKComponent {
    
    private(set) var currentSpeed: Speed = .v2 {
        didSet {
            if currentSpeed == .v0 {
                GameManager.shared.playerHealth?.die()
            }
        }
    }

    func incrementSpeed() {
        if currentSpeed == .v4 { return }

        if let newSpeed = Speed(rawValue: currentSpeed.rawValue + 1) {
            currentSpeed = newSpeed
            print("accelerating to \(currentSpeed)")
        }
    }

    func decrementSpeed() {
        switch currentSpeed {
        case .v0:
            print("already dead")
        case .v1:
            currentSpeed = .v0
        case .v2:
            currentSpeed = .v1
        default:
            currentSpeed = .v2
        }
        print("decelerating to \(currentSpeed)")
    }

    func changeSpeed(to newSpeed: Speed) {
        currentSpeed = newSpeed
    }
}
