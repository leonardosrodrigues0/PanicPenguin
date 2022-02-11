import GameplayKit

protocol SpawnableObject: GKEntity {
    static func spawn(at position: SCNVector3)
    static var spawnType: PhysicsCategory { get }
    func collideWithSpawnableObject(category: PhysicsCategory)
}

extension SpawnableObject {
    static func spawn(at position: SCNVector3) {
        let obj = self.init()
        let geometry = obj.component(ofType: GeometryComponent.self)
        geometry?.node.position = position
        geometry?.node.eulerAngles = SCNVector3(0, Int.random(in: 0..<360), 0)
        GameManager.shared.scene?.add(obj)
    }

    func collide(category: PhysicsCategory) {
        switch category {
        case .player:
            collideWithPlayer()
        case .obstacle, .coin, .powerUp:
            collideWithSpawnableObject(category: category)
        default:
            return
        }
    }

    /// Remove object if its spawn distance is smaller than or equal to the other object.
    func collideWithSpawnableObject(category: PhysicsCategory) {
        if Self.spawnType.minimumSpawnDistance <= category.minimumSpawnDistance {
            removeEntityBody()
        }
    }

    func collideWithPlayer() {
        removeEntityBody()
    }

    func removeEntityBody() {
        self.removeComponent(ofType: PhysicsComponent.self)
        self.removeComponent(ofType: ContactComponent.self)
        self.removeComponent(ofType: GeometryComponent.self)
    }
}

extension PhysicsCategory {

    /// The minimum z distance between 2 objects of the category
    var minimumSpawnDistance: Double {
        switch self {
        case .powerUp:
            return 4
        case .coin:
            return 2
        case .obstacle:
            return 0.2
        default:
            return 1
        }
    }

    /// The probability that an object will spawn in a game cycle after the minimum
    /// distance from the last spawned object of that type has been reached.
    ///
    /// A higher value means a more "random" distribution in the z axis, but will make
    /// the game easier. To balance difficulty, the `minimumSpawnDistance` can
    /// be decreased.
    var spawnProbability: Double {
        switch self {
        case .powerUp:
            return 0.05
        case .coin:
            return 0.05
        case .obstacle:
            return 0.05
        default:
            return 1
        }
    }
}

class ObjectSpawnerComponent<T: SpawnableObject>: GKComponent {
    private var timeSinceLastSpawn: Double = 0

    func spawnThing() {
        T.spawn(at: SCNVector3(Double.random(in: Config.xMovementRange), 0.25, -100))
    }

    override func update(deltaTime seconds: TimeInterval) {
        timeSinceLastSpawn += seconds

        if timeSinceLastSpawn >= T.spawnType.minimumSpawnDistance / GameManager.shared.currentSpeed.rawValue {
            if Double.random(in: 0 ... 1) <= T.spawnType.spawnProbability {
                spawnThing()
                timeSinceLastSpawn = 0
            }
        }
    }
}
