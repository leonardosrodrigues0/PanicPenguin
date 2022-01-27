import GameplayKit

class Spawner<T: SpawnableObject>: GKEntity {
    override init(type: SpawnedObjectType) {
        super.init()
        addComponent(ObjectSpawnerComponent<T>(type: type))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
