import GameplayKit

protocol SpawnableObject: GKEntity {
    static var spawnType: PhysicsCategory { get }
    static var spawnHeight: Double { get }
    static var spawnPosition: SCNVector3 { get }
    static var poolSize: Int { get }
    func collideWithSpawnableObject(category: PhysicsCategory)
}

extension SpawnableObject {
    static var spawnHeight: Double {
        0
    }

    static var poolSize: Int {
        return 20
    }

    static var spawnPosition: SCNVector3 {
        SCNVector3(Double.random(in: Config.xMovementRange), spawnHeight, -100)
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
            removeAndReturnToPool()
        }
    }

    func collideWithPlayer() {
        removeAndReturnToPool()
    }

    private func removeAndReturnToPool() {
        GameManager.shared.scene?.remove(self)
        spawnerComponent?.returnToPool(self)
    }

    private var spawnerComponent: ObjectSpawnerComponent<Self>? {
        GameManager.shared.scene?.entities.first { entity in
            entity as? Spawner<Self> != nil
        }?.component(ofType: ObjectSpawnerComponent<Self>.self)
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
        case .scenario:
            return 0.3
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
        case .scenario:
            return 1
        default:
            return 1
        }
    }
}

class ObjectSpawnerComponent<T: SpawnableObject>: GKComponent {
    private var timeSinceLastSpawn: Double = 0
    private var pool: [T]

    override init() {
        pool = []
        for _ in 0 ..< T.poolSize {
            pool.append(T())
        }

        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func spawnThing() {
        guard let obj = pool.popLast() else {
            print("Empty pool for object type \(T.self)")
            return
        }

        let geometry = obj.component(ofType: GeometryComponent.self)
        geometry?.node.position = T.spawnPosition
        geometry?.node.eulerAngles = SCNVector3(0, Int.random(in: 0 ..< 360), 0)
        GameManager.shared.scene?.add(obj)
    }

    func returnToPool(_ object: T) {
        pool.append(object)
    }

    override func update(deltaTime seconds: TimeInterval) {
        verifyTimeAndSpawn(deltaTime: seconds)
        verifyObjectsAndRemove()
    }

    private func verifyTimeAndSpawn(deltaTime seconds: TimeInterval) {
        timeSinceLastSpawn += seconds

        if timeSinceLastSpawn >= T.spawnType.minimumSpawnDistance / GameManager.shared.currentSpeed.rawValue {
            if Double.random(in: 0 ... 1) <= T.spawnType.spawnProbability {
                spawnThing()
                timeSinceLastSpawn = 0
            }
        }
    }

    private func verifyObjectsAndRemove() {
        guard let scene = GameManager.shared.scene else {
            print("Invalid game scene when trying to remove objects")
            return
        }

        let objects = scene.entities.compactMap { $0 as? T }

        for object in objects {
            let position = object.component(ofType: GeometryComponent.self)!.node.position.z
            if position > 0 {
                scene.remove(object)
                returnToPool(object)
            }
        }
    }
}
