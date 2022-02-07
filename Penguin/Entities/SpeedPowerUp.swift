//
//  PowerUp.swift
//  Penguin
//
//  Created by Matheus Vicente on 27/01/22.
//
import GameplayKit
import SceneKit

class SpeedPowerUp: GKEntity {

    static var geometry: SCNGeometry {
        let material = SCNMaterial()
//        material.reflective.contents = UIColor.blue
        material.diffuse.contents = UIColor.blue
        let geometry = SCNSphere(radius: 1.0)
        geometry.materials = [material]
        return geometry
    }

    static var physicsBody: SCNPhysicsBody {
        let body = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: geometry, options: nil))
        body.categoryBitMask = PhysicsCategory.powerUp.rawValue

        return body
    }

    override init() {
        super.init()
        let position = SCNVector3(0, 0.25, -25)
        let geometryComponent = GeometryComponent(geometry: Self.geometry, position: position)
        geometryComponent.node.scale.y = 0.5
        addComponent(geometryComponent)
        addComponent(PhysicsComponent(withBody: Self.physicsBody))
        addComponent(ObstacleMovementComponent())
        addComponent(ContactComponent(with: [.player, .obstacle, .coin, .powerUp]) { category in
            self.collide(category: category)
        })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SpeedPowerUp: SpawnableObject {
    static let spawnType: PhysicsCategory = .powerUp
}
