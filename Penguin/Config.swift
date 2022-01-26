import Foundation

enum Config {
    static let interval: Double = 1 / 60
    static let minXPosition: Float = -5.5
    static let maxXPosition: Float = 5.5
    static let xRange = (minXPosition...maxXPosition)
}
