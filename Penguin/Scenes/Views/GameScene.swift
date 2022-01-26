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
    
    func spawnThing() {
        var time = Timer()
        time = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            let tree = Tree()
            if let spriteComponent = tree.component(ofType: GeometryComponent.self) {
                spriteComponent.node.position = SCNVector3(Float.random(in: -5.5...5.5),0.25, -50)
                self.add(tree)
            }
        })
    }
}

