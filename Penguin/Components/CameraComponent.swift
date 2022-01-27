import GameplayKit
import SceneKit

class CameraComponent: GKComponent {
    private let camera: SCNCamera
    private let orientation: SCNVector3
    
    init(orientation: SCNVector3, fieldOfView: CGFloat? = nil) {
        camera = SCNCamera()
        if let fieldOfView = fieldOfView {
            camera.fieldOfView = fieldOfView
        }
        self.orientation = orientation
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        guard let node = entity?.component(ofType: GeometryComponent.self)?.node else {
            return
        }
        
        node.eulerAngles = orientation
        node.camera = camera
    }
}
