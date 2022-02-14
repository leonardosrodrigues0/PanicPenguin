import GameplayKit
import SceneKit

class GeometryComponent: GKComponent {

    var node: SCNNode

    init(geometry: SCNGeometry?, position: SCNVector3 = SCNVector3(0, 0, 0)) {
        node = SCNNode(geometry: geometry)
        node.position = position
        super.init()
    }

    init(scene: SCNScene, position: SCNVector3 = SCNVector3(0, 0, 0)) {
        node = scene.rootNode
        node.position = position
        super.init()
    }

    init(scene: SCNScene, nodeWithName name: String, position: SCNVector3 = SCNVector3(0, 0, 0)) {
        node = scene.rootNode.childNode(withName: name, recursively: true)!.clone()
        node.position = position
        super.init()
    }

    init(scene: SCNScene, atIndex index: Int = 0, position: SCNVector3 = SCNVector3(0, 0, 0)) {
        node = scene.rootNode.childNodes[index].clone()
        node.position = position
        super.init()
    }

    func setPhysicsBody(_ body: SCNPhysicsBody) {
        node.physicsBody = body
    }

    override func update(deltaTime seconds: TimeInterval) {
        if node.position.z > 0 {
            GameManager.shared.scene?.remove(self.entity!)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func willRemoveFromEntity() {
        node.removeFromParentNode()
    }
}
