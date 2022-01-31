import SceneKit
import GameplayKit

class Player: GKEntity {

    static var geometry: SCNGeometry {
        let material = SCNMaterial()
        material.reflective.contents = UIColor.blue
        material.diffuse.contents = UIColor.blue
        let geometry = SCNBox(width: 3, height: 0.5, length: 3, chamferRadius: 0.2)
        geometry.materials = [material]
        return geometry
    }

    static var physicsBody: SCNPhysicsBody {
        let body = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: geometry, options: nil))
        body.velocityFactor = SCNVector3(0, 1, 0)
        body.angularVelocityFactor = SCNVector3(1, 0, 0)
        body.categoryBitMask = PhysicsCategory.player.rawValue
        body.collisionBitMask = PhysicsCategory.bitMask(forCategories: [
            PhysicsCategory.ground
//            PhysicsCategory.obstacle
        ])

        return body
    }
    
    lazy private var animationComponent: AnimationComponent = {
        let component = AnimationComponent(animations: [
            .shake: .sequence([
                SCNAction.rotateBy(x: 0, y: 5.0.toRad, z: 0, duration: 0.1),
                SCNAction.rotateBy(x: 0, y: -10.0.toRad, z: 0, duration: 0.1),
                SCNAction.rotateBy(x: 0, y: 5.0.toRad, z: 0, duration: 0.05)
            ]),
            .scale: .sequence([
                SCNAction.scale(to: 1.1, duration: 0.1),
                SCNAction.scale(to: 0.9, duration: 0.1),
                SCNAction.scale(to: 1, duration: 0.05)
            ])
        ])
        return component
    }()

    override init() {
        super.init()
        addComponent(GeometryComponent(geometry: Self.geometry, position: .init(0, 0.25, -25)))
        addComponent(PhysicsComponent(withBody: Self.physicsBody))
        addComponent(PlayerMovementComponent())
        let healthComponent = PlayerHealthComponent()
        addComponent(healthComponent)
        addComponent(ContactComponent(with: [.obstacle, .collectable], { category in
            switch category {
            case .obstacle:
                self.animationComponent.run(.shake)
                self.animationComponent.run(.scale)
                healthComponent.hit()
            default:
                return
            }
        }))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
