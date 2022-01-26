import GameplayKit
import SceneKit

class PhysicsComponent: GKComponent {
    
    var physicsBody: SCNPhysicsBody? {
        geometryComponent?.node.physicsBody
    }

    private var geometryComponent: GeometryComponent? {
        entity?.component(ofType: GeometryComponent.self)
    }

    init(withBody body: SCNPhysicsBody) {
        super.init()
        geometryComponent?.setPhysicsBody(body)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
