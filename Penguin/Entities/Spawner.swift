//
//  Spawner.swift
//  Penguin
//
//  Created by Erick Manaroulas Felipe on 26/01/22.
//

import GameplayKit

class Spawner: GKEntity {
    init(object: SpawnableObject, type: SpawnedObjectType) {
        super.init()
        addComponent(ObjectSpawnerComponent(object: object, type: type))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
