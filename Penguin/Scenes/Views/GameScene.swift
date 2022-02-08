import SceneKit
import GameplayKit

class GameScene: SCNScene {
    
    var entities = Set<GKEntity>()

    override init() {
        super.init()
        physicsWorld.contactDelegate = self
        isPaused = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
        if let node = entity.component(ofType: GeometryComponent.self)?.node {
            rootNode.addChildNode(node)
            node.entity = entity
        }
    }
    
    func remove(_ entity: GKEntity) {
        if let node = entity.component(ofType: GeometryComponent.self)?.node {
            node.removeFromParentNode()
            node.entity = nil
        }
        
        entities.remove(entity)
    }
    
}

extension GameScene: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        guard
            let contactComponentA = contact.nodeA.entity?.component(ofType: ContactComponent.self),
            let contactComponentB = contact.nodeB.entity?.component(ofType: ContactComponent.self)
        else {
            return
        }

        guard
            let nodeACategory = PhysicsCategory(rawValue: contact.nodeB.physicsBody?.categoryBitMask ?? 0),
            let nodeBCategory = PhysicsCategory(rawValue: contact.nodeB.physicsBody?.categoryBitMask ?? 0)
        else {
            print("Invalid collision")
            return
        }
        
        // Trigger the action of each entity
        contactComponentA.action(nodeBCategory)
        contactComponentB.action(nodeACategory)
        
        // IMPORTANT: - The action of an obstacle needs to set its contactTestBitMask of to 0, so this function is called only once
    }
}
