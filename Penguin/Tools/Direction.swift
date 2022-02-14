import Foundation

enum Direction: Int {
    case left = -1
    case right = 1

    static var random: Direction {
        if Int.random(in: 0 ... 1) == 0 {
            return .left
        } else {
            return .right
        }
    }
}
