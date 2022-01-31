import GameplayKit

protocol SpawnableObject: GKEntity {
    static func spawn(at position: SCNVector3)
    static var spawnType: SpawnedObjectType { get }
}

extension SpawnableObject {
    static func spawn(at position: SCNVector3) {
        let obj = self.init()
        obj.component(ofType: GeometryComponent.self)?.node.position = position
        GameManager.shared.scene?.add(obj)
    }
}

enum SpawnedObjectType {
    case powerUp
    case coin
    case obstacle

    var spawnDistance: Double {
        // distances may not be divisible between each other
        switch self {
        case .powerUp:
            return 11.082
        case .coin:
            return 4.190
        case .obstacle:
            return 0.667
        }
    }
}

class ObjectSpawnerComponent<T: SpawnableObject>: GKComponent {
    var timeSinceLastSpawn: Double = 0

    func spawnThing() {
        T.spawn(at: SCNVector3(Double.random(in: Config.xRange), 0.25, -100))
    }

    override func update(deltaTime currentTime: TimeInterval) {
        if timeSinceLastSpawn == 0 {
            timeSinceLastSpawn = currentTime
        }

        let deltaTime = currentTime - timeSinceLastSpawn

        if deltaTime >= T.spawnType.spawnDistance / GameManager.shared.currentSpeed.rawValue {
            spawnThing()
            timeSinceLastSpawn = currentTime
        }
    }
}
