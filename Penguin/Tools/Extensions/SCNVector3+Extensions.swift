//
//  SCNVector3+Extensions.swift
//  Penguin
//
//  Created by Erick Manaroulas Felipe on 25/01/22.
//

import SceneKit

extension SCNVector3 {
    static func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
    }

    static func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
    }

    static func += (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return left + right
    }

    static func -= (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return left - right
    }

    static func * (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.x * right.x, left.y * right.y, left.z * right.z)
    }

    static func / (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.x / right.x, left.y / right.y, left.z / right.z)
    }

    static func *= (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return left * right
    }

    static func /= (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return left / right
    }

}
