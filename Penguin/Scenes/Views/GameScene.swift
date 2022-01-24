import SceneKit
import GameplayKit

class GameScene: SCNScene {

    var entities = Set<GKEntity>()

    func add(_ entity: GKEntity) {
        entities.insert(entity)

        if let node = entity.component(ofType: GeometryComponent.self)?.node {
            rootNode.addChildNode(node)
        }
    }

    func remove(_ entity: GKEntity) {
        if let node = entity.component(ofType: GeometryComponent.self)?.node {
            node.removeFromParentNode()
        }

        entities.remove(entity)
    }
}
