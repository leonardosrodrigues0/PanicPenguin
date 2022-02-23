import GameplayKit
import SceneKit

class SpeedPowerUp: GKEntity {

    static let scene = SCNScene(named: "models.scnassets/Fish/PowerUp.scn")!

    static var physicsBody: SCNPhysicsBody {
        let body = SCNPhysicsBody(
            type: .kinematic,
            shape: SCNPhysicsShape(
                geometry: SCNBox(width: 1, height: 10, length: 1, chamferRadius: 0),
                options: nil
            )
        )

        body.categoryBitMask = PhysicsCategory.powerUp.rawValue
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

extension SpeedPowerUp: SpawnableObject {
    static let spawnType: PhysicsCategory = .powerUp
    static let spawnHeight: Double = 1
    static let poolSize: Int = 5
}
