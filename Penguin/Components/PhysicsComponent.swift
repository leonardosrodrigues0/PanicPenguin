import GameplayKit
import SceneKit

class PhysicsComponent: GKComponent {
    
    var physicsBody: SCNPhysicsBody

    private var geometryComponent: GeometryComponent? {
        entity?.component(ofType: GeometryComponent.self)
    }

    init(withBody body: SCNPhysicsBody) {
        physicsBody = body
        super.init()
    }

    override func didAddToEntity() {
        geometryComponent?.setPhysicsBody(physicsBody)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
