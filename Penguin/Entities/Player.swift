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
            .hit: .group([
                .sequence([
                    SCNAction.rotateBy(x: 0, y: 5.0.toRad, z: 0, duration: 0.1),
                    SCNAction.rotateBy(x: 0, y: -10.0.toRad, z: 0, duration: 0.1),
                    SCNAction.rotateBy(x: 0, y: 5.0.toRad, z: 0, duration: 0.05)
                ]),
                .sequence([
                    SCNAction.scale(to: 1.1, duration: 0.1),
                    SCNAction.scale(to: 0.9, duration: 0.1),
                    SCNAction.scale(to: 1, duration: 0.05)
                ])
            ]),
            .idle: .repeatForever(
                .sequence([
                    .moveBy(x: 0, y: 0.45, z: 0, duration: 0.35),
                    .moveBy(x: 0, y: -0.45, z: 0, duration: 0.35)
                ])
            )
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
        let musicComponent = MusicComponent()
        addComponent(musicComponent)
        addComponent(animationComponent)
        addComponent(ParticleEffectComponent(.snowTrail, at: .init(.mid, .bottom, .back)))
        addComponent(ContactComponent(with: [.obstacle, .coin, .powerUp], { category in
            switch category {
            case .obstacle:
                self.animationComponent.run(.hit)
                musicComponent.hitObstacleSound()
                healthComponent.hit()
            case .powerUp:
                GameManager.shared.speedManager.changeSpeed(to: .v5)
                musicComponent.powerUpSound()
            case .coin:
                GameManager.shared.scoreManager.collectCoin()
                musicComponent.coinSound()
            default:
                return
            }
        }))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
