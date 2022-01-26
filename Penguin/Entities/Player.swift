import SceneKit
import GameplayKit

class Player: GKEntity {

    static var geometry: SCNGeometry {
        let material = SCNMaterial()
        material.reflective.contents = UIColor.blue
        material.diffuse.contents = UIColor.lightGray
        let geometry = SCNBox(width: 3, height: 0.5, length: 3, chamferRadius: 0.2)
        geometry.materials = [material]
        return geometry
    }

    static var physicsBody: SCNPhysicsBody {
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: geometry, options: nil))
        body.velocityFactor = SCNVector3(0, 1, 0)
        body.angularVelocityFactor = SCNVector3(1, 0, 0)
        body.categoryBitMask = PhysicsCategory.player.rawValue
        body.collisionBitMask = PhysicsCategory.bitMask(forCategories: [
            PhysicsCategory.ground
//            PhysicsCategory.obstacle
        ])

        return body
    }

    override init() {
        super.init()
        let position = SCNVector3(0, 0.25, -25)
        addComponent(GeometryComponent(geometry: Self.geometry, position: position))
        addComponent(PhysicsComponent(withBody: Self.physicsBody))
        addComponent(PlayerMovementComponent())
        addComponent(PlayerHealthComponent())
        addComponent(ContactComponent(with: [.obstacle], {
            // Here you can lower the speed of our player
            print("contato")
        }))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
