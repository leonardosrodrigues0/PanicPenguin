import Foundation

enum Config {
    static let interval: Double = 1 / 60

    static let minXPosition: Float = -5.5
    static let maxXPosition: Float = 5.5
    static let xRange = (minXPosition...maxXPosition)
    
    static let baseScore: Double = 0.1

    static var coinValue: Double {
        return Double(GameManager.shared.currentSpeed.rawValue * 5)
    }

    static func timer(for type: SpawnedObjectType) -> Double {
        // timers may not be divisible between each other
        switch type {
        case .powerup:
            return 4.9
        case .coin:
            return 2.1
        case .obstacle:
            return 0.6
        }
    }
}
