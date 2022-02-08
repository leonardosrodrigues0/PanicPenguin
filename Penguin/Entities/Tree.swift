import GameplayKit
import SceneKit

class Tree: GKEntity {

    static var geometry: SCNGeometry {
        let material = SCNMaterial()
//        material.reflective.contents = UIColor.red
        material.diffuse.contents = UIColor.red
        let geometry = SCNBox(width: 1.5, height: 0.5, length: 1.5, chamferRadius: 0.2)
        geometry.materials = [material]
        return geometry
    }

    static var physicsBody: SCNPhysicsBody {
        let body = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: geometry, options: nil))
        body.categoryBitMask = PhysicsCategory.obstacle.rawValue

        return body
    }

    override init() {
        super.init()
        let position = SCNVector3(0, 0.25, -25)
        addComponent(GeometryComponent(geometry: Self.geometry, position: position))
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

extension Tree: SpawnableObject {
    static let spawnType: PhysicsCategory = .obstacle
}
