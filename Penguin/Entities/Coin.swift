//
//  Coin.swift
//  Penguin
//
//  Created by Erick Manaroulas Felipe on 27/01/22.
//

import GameplayKit
import SceneKit

class Coin: GKEntity {

    static let scene = SCNScene(named: "models.scnassets/Fish/Coin.scn")!

    static var geometry: SCNGeometry {
        let geometryNode = scene.rootNode.childNode(withName: "Coin", recursively: true)
        return geometryNode!.geometry!
    }

    static var physicsBody: SCNPhysicsBody {
        let body = SCNPhysicsBody(
            type: .kinematic,
            shape: SCNPhysicsShape(
                geometry: geometry,
                options: nil
            )
        )

        body.categoryBitMask = PhysicsCategory.coin.rawValue
        return body
    }

    override init() {
        super.init()
        addComponent(GeometryComponent(scene: Self.scene, nodeWithName: "Armature"))
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

extension Coin: SpawnableObject {
    static let spawnType: PhysicsCategory = .coin
    static let spawnHeight: Double = 1
}
