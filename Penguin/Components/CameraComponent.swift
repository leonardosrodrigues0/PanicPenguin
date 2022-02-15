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

    override func update(deltaTime seconds: TimeInterval) {
        guard let node = entity?.component(ofType: GeometryComponent.self)?.node else {
            print("FALHOUUU")
            return
        }

        guard let newPosition = GameManager.shared.playerMovement?.entity?.component(ofType: GeometryComponent.self)?.node.position else {
            print("AAAAAAAA")
            return
        }

        node.position = newPosition + SCNVector3(0, 2, 3)
    }
}
