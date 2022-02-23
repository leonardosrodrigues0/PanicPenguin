import GameplayKit
import SceneKit

class ScenarioObject: GKEntity {

    static let scene = SCNScene(named: "models.scnassets/Objects/Objects.scn")!

    var geometry: SCNGeometry? {
        return self.component(ofType: GeometryComponent.self)?.node.geometry
    }

    var node: SCNNode? {
        return self.component(ofType: GeometryComponent.self)?.node
    }

    var physicsBody: SCNPhysicsBody {
        let body = SCNPhysicsBody(
            type: .kinematic,
            shape: SCNPhysicsShape(
                geometry: geometry ?? SCNBox(width: 1.5, height: 1.5, length: 1.5, chamferRadius: 0),
                options: [.scale: node?.scale ?? SCNVector3(1, 1, 1)]
            )
        )
        return body
    }

    override init() {
        super.init()
        addComponent(GeometryComponent(
            scene: ScenarioObject.scene,
            atIndex: Int.random(in: 0 ..< Obstacle.scene.rootNode.childNodes.count)
        ))
        addComponent(PhysicsComponent(withBody: physicsBody))
        addComponent(ObstacleMovementComponent())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScenarioObject: SpawnableObject {
    static let spawnType: PhysicsCategory = .scenario
    static var spawnPosition: SCNVector3 {
        let direction = Direction.random
        return SCNVector3(Double(direction.rawValue) * (Config.xMovementRange.upperBound + 3), Self.spawnHeight, -100)
    }
}
