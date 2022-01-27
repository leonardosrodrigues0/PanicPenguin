import GameplayKit
import SceneKit

class Tree: GKEntity {

    static var geometry: SCNGeometry {
        let material = SCNMaterial()
        material.reflective.contents = UIColor.red
        material.diffuse.contents = UIColor.lightGray
        let geometry = SCNBox(width: 1.5, height: 0.5, length: 1.5, chamferRadius: 0.2)
        geometry.materials = [material]
        return geometry
    }

    static var physicsBody: SCNPhysicsBody {
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: geometry, options: nil))
        body.velocityFactor = SCNVector3(0, 1, 0)
        body.angularVelocityFactor = SCNVector3(1, 0, 0)
        body.categoryBitMask = PhysicsCategory.obstacle.rawValue
        body.collisionBitMask = PhysicsCategory.bitMask(forCategories: [
            PhysicsCategory.ground
//            PhysicsCategory.player
        ])

        return body
    }

    override init() {
        super.init()
        let position = SCNVector3(0, 0.25, -25)
        addComponent(GeometryComponent(geometry: Self.geometry, position: position))
        addComponent(PhysicsComponent(withBody: Self.physicsBody))
        addComponent(ObstacleMovementComponent())
        addComponent(ContactComponent(with: [.player]) {
            self.removeComponent(ofType: PhysicsComponent.self)
            self.removeComponent(ofType: ContactComponent.self)
            self.removeComponent(ofType: GeometryComponent.self)
        })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Tree: SpawnableObject {
    static func spawn(at position: SCNVector3) {
        let obj = Tree()
        obj.component(ofType: GeometryComponent.self)?.node.position = position
        GameManager.shared.scene?.add(obj)
    }
}
