import SceneKit
import GameplayKit

class GameScene: SCNScene {

    var entities = Set<GKEntity>()
    private let scoreTracker = ScoreTracker()

    func play() {
        self.isPaused = false
        scoreTracker.startScoreUpdates()
    }

    func pause() {
        self.isPaused = true
        scoreTracker.pauseScoreUpdates()
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
