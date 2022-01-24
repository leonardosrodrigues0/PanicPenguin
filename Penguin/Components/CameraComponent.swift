import GameplayKit
import SceneKit

class CameraComponent: GKComponent {

    init(orientation: SCNVector3, geometry: GeometryComponent) {
        super.init()
        let camera = SCNCamera()
        geometry.addCamera(camera, withOrientation: orientation)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
