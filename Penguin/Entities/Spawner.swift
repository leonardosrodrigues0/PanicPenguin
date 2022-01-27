import GameplayKit

class Spawner<T: SpawnableObject>: GKEntity {
    override init() {
        super.init()
        addComponent(ObjectSpawnerComponent<T>())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
