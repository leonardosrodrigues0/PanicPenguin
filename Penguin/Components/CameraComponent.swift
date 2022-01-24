import GameplayKit
import SceneKit

class CameraComponent: GKComponent {

    var geometryComponent: GeometryComponent? {
        entity?.component(ofType: GeometryComponent.self)
    }

    init(orientation: SCNVector3) {
        super.init()
        let camera = SCNCamera()
        geometryComponent?.addCamera(camera, withOrientation: orientation)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
