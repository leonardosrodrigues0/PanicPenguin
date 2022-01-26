//
//  ObjectSpawnerComponent.swift
//  Penguin
//
//  Created by Erick Manaroulas Felipe on 26/01/22.
//

import GameplayKit

protocol SpawnableObject: GKEntity {
    func spawn(at position: SCNVector3)
}

enum SpawnedObjectType {
    case powerup
    case coin
    case obstacle
}

class ObjectSpawnerComponent: GKComponent {

    var entityToSpawn: SpawnableObject
    var timeSinceLastSpawn: Double = 0

    init(object: SpawnableObject) {
        entityToSpawn = object
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func spawnThing() {
        entityToSpawn.spawn(at: SCNVector3(Float.random(in: -5.5...5.5), 0.25, -200))
    }

    override func update(deltaTime currentTime: TimeInterval) {
        if timeSinceLastSpawn == 0 {
            timeSinceLastSpawn = currentTime
        }

        let deltaTime = currentTime - timeSinceLastSpawn

        if deltaTime >= 0.3 {
            spawnThing()
            timeSinceLastSpawn = currentTime
        }
    }
}
