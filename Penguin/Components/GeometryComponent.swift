import GameplayKit
import SceneKit

class GeometryComponent: GKComponent {

    let node: SCNNode

    init(geometry: SCNGeometry?, position: SCNVector3 = SCNVector3(0, 0, 0)) {
        node = SCNNode(geometry: geometry)
        node.position = position
        super.init()
    }

    func setPhysicsBody(_ body: SCNPhysicsBody) {
        node.physicsBody = body
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func willRemoveFromEntity() {
        node.removeFromParentNode()
    }
}
