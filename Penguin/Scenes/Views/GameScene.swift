import SceneKit
import GameplayKit

class GameScene: SCNScene {

    var entities = Set<GKEntity>()
    private let scoreTracker = ScoreTracker()

    var score: Int {
        scoreTracker.score
    }

    func togglePaused() {
        if self.isPaused {
            play()
        } else {
            pause()
        }
    }

    func play() {
        self.isPaused = false
        scoreTracker.startScoreUpdates()
    }

    func pause() {
        self.isPaused = true
        scoreTracker.pauseScoreUpdates()
    }

    override init() {
        super.init()
        physicsWorld.contactDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

extension GameScene: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        guard
            let contactComponentA = contact.nodeA.entity?.component(ofType: ContactComponent.self),
            let contactComponentB = contact.nodeB.entity?.component(ofType: ContactComponent.self)
        else {
            return
        }
        
        // Trigger the action of each entity
        contactComponentA.action()
        contactComponentB.action()
        
        // IMPORTANT: - The action of an obstacle needs to set its contactTestBitMask of to 0, so this function is called only once
    }
}
