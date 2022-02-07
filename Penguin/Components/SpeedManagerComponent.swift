import GameplayKit

enum Speed: Double {
    case v0 = 0.0
    case v1 = 0.7
    case v2 = 0.9
    case v3 = 1.1
    case v4 = 1.3
    case v5 = 1.6

    var next: Speed? {
        switch self {
        case .v0:
            return .v1
        case .v1:
            return .v2
        case .v2:
            return .v3
        case .v3:
            return .v4
        case .v4:
            return .v5
        case .v5:
            return nil
        }
    }

    var previous: Speed? {
        switch self {
        case .v0:
            return nil
        case .v1:
            return .v0
        case .v2:
            return .v1
        case .v3:
            return .v2
        case .v4:
            return .v3
        case .v5:
            return .v4
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
                GameManager.shared.die()
            }
        }
    }

    func incrementSpeed() {
        if currentSpeed == .v4 { return }

        if let newSpeed = currentSpeed.next {
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
