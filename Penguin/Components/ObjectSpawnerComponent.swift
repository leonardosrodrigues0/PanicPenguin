import GameplayKit

protocol SpawnableObject: GKEntity {
    static func spawn(at position: SCNVector3) -> SpawnableObject
    static var spawnType: SpawnedObjectType { get }
    func respawn(at position: SCNVector3)
    func prepareForReuse()
    func deSpawn()
}

extension SpawnableObject {
    static func spawn(at position: SCNVector3) -> SpawnableObject {
        let obj = self.init()
        obj.component(ofType: GeometryComponent.self)?.node.position = position
        GameManager.shared.scene?.add(obj)
        return obj
    }

    func respawn(at position: SCNVector3) {
        prepareForReuse()
        self.component(ofType: GeometryComponent.self)?.node.position = position
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
    private var timeSinceLastSpawn: Double = 0
    var pool = [SpawnableObject]()
    var poolMaxSize = 30

    var spawnPosition: SCNVector3 {
        return SCNVector3(Double.random(in: Config.xMovementRange), 0.25, -100)
    }

    func spawnThing() {
        var obj: SpawnableObject?
        if pool.count >= poolMaxSize {
            obj = pool.removeFirst()
            obj?.respawn(at: spawnPosition)
        } else {
            obj = T.spawn(at: spawnPosition)
        }

        if obj != nil {
            pool.append(obj!)
        }

        print(pool.count)
    }

    override func update(deltaTime seconds: TimeInterval) {
        timeSinceLastSpawn += seconds

        if timeSinceLastSpawn >= T.spawnType.spawnDistance / GameManager.shared.currentSpeed.rawValue {
            spawnThing()
            timeSinceLastSpawn = 0
        }
    }
}
