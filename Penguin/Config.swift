import Foundation

enum Config {
    static let interval: Double = 1 / 60

    static let minXPosition: Double = -5.5
    static let maxXPosition: Double = 5.5
    static let xRange = (minXPosition...maxXPosition)
    
    static let baseScore: Double = 0.01

    static var baseCoinValue: Int = 5
}
