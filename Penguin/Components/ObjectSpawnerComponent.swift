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

    func spawnThing() {
        T.spawn(at: SCNVector3(Float.random(in: Config.xRange), 0.25, -100))
    }

    override func update(deltaTime currentTime: TimeInterval) {
        if timeSinceLastSpawn == 0 {
            timeSinceLastSpawn = currentTime
        }

        let deltaTime = currentTime - timeSinceLastSpawn

        if deltaTime >= 1 {
            spawnThing()
            timeSinceLastSpawn = currentTime
        }
    }
}
