//
//  Math.swift
//  Penguin
//
//  Created by Erick Manaroulas Felipe on 27/01/22.
//

import Foundation
import CoreGraphics

extension Double {
    var toRad: Double {
        return self / 180 * Self.pi
    }

    var toDegree: Double {
        return self * 180 / Self.pi
    }
}

extension Float {
    var toRad: Float {
        return self / 180 * Self.pi
    }
}

extension CGFloat {
    var toRad: CGFloat {
        return self / 180 * Self.pi
    }
}
