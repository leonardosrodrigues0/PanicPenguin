import Foundation

enum PhysicsCategory: Int {
    case player = 1
    case obstacle = 2
    case ground = 4
    case coin = 8
    case powerUp

    static func bitMask(forCategories categories: [PhysicsCategory]) -> Int {
        categories.reduce(0) { partialResult, category in
            partialResult | category.rawValue
        }
    }
}
