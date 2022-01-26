import SceneKit
import GameplayKit

class Ground: GKEntity {

    static var geometry: SCNGeometry {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.yellow
        let geometry = SCNFloor()
        geometry.reflectivity = 0.5
        geometry.materials = [material]
        return geometry
    }

    static var physicsBody: SCNPhysicsBody {
        let body = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: geometry, options: nil))
        body.categoryBitMask = PhysicsCategory.ground.rawValue
//        body.contactTestBitMask = PhysicsCategory.ground.rawValue
        body.collisionBitMask = PhysicsCategory.bitMask(forCategories: [
            PhysicsCategory.obstacle,
            PhysicsCategory.player
        ])

        return body
    }

    override init() {
        super.init()
        addComponent(GeometryComponent(geometry: Self.geometry))
        addComponent(PhysicsComponent(withBody: Self.physicsBody))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
