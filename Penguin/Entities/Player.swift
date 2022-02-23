import SceneKit
import GameplayKit

class Player: GKEntity {

    static var scene: SCNScene {
        return SCNScene(named: "models.scnassets/Penguin/Penguin_Rigged.scn")!
    }

    static var geometry: SCNGeometry {
        let geometryNode = scene.rootNode.childNode(withName: "Model", recursively: true)
        return geometryNode!.geometry!
    }

    static var physicsBody: SCNPhysicsBody {
        let body = SCNPhysicsBody(
            type: .kinematic,
            shape: SCNPhysicsShape(geometry: Self.geometry, options: nil)
        )
        body.velocityFactor = SCNVector3(0, 1, 0)
        body.angularVelocityFactor = SCNVector3(1, 0, 0)
        body.categoryBitMask = PhysicsCategory.player.rawValue
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
        let position = SCNVector3(0, -0.15, -25)
        addComponent(GeometryComponent(scene: Self.scene, position: position))
        addComponent(PhysicsComponent(withBody: Self.physicsBody))
        addComponent(PlayerMovementComponent())
        let healthComponent = PlayerHealthComponent()
        addComponent(healthComponent)
        addComponent(animationComponent)
        addComponent(ParticleEffectComponent(.snowTrail, at: .init(.mid, .bottom, .mid)))
        addComponent(ContactComponent(with: [.obstacle, .coin, .powerUp], { category in
            GameManager.shared.soundManager.triggerSoundEffect(SoundEffectOrigin.fromCategory(category), fromEntity: self)
            switch category {
            case .obstacle:
                self.animationComponent.run(.hit)
                healthComponent.hit()
            case .powerUp:
                GameManager.shared.speedManager.changeSpeed(to: .v5)
            case .coin:
                GameManager.shared.scoreManager.collectCoin()
            default:
                return
            }
        }))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
