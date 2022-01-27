import GameplayKit

protocol SpawnableObject: GKEntity {
    static func spawn(at position: SCNVector3)
}

enum SpawnedObjectType {
    case powerup
    case coin
    case obstacle
}

class ObjectSpawnerComponent<T: SpawnableObject>: GKComponent {
    var timeSinceLastSpawn: Double = 0
    var spawnType: SpawnedObjectType

    init(type: SpawnedObjectType) {
        self.spawnType = type
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func spawnThing() {
        T.spawn(at: SCNVector3(Float.random(in: Config.xRange), 0.25, -100))
    }

    override func update(deltaTime currentTime: TimeInterval) {
        if timeSinceLastSpawn == 0 {
            timeSinceLastSpawn = currentTime
        }

        let deltaTime = currentTime - timeSinceLastSpawn

        if deltaTime >= Config.timer(for: spawnType) {
            spawnThing()
            timeSinceLastSpawn = currentTime
        }
    }
}
