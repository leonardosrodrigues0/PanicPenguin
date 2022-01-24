import GameplayKit
import SceneKit

class PhysicsComponent: GKComponent {

    var geometryComponent: GeometryComponent? {
        entity?.component(ofType: GeometryComponent.self)
    }

    init(withBody body: SCNPhysicsBody) {
        super.init()
        geometryComponent?.updatePhysicsBody(body)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
