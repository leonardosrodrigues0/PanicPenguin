import SceneKit
import GameplayKit

class Camera: GKEntity {

    override init() {
        super.init()
        let position = SCNVector3(x: 0, y: 25, z: -18)
        addComponent(GeometryComponent(geometry: nil, position: position))
        let orientation = SCNVector3(x: -1, y: 0, z: 0)
        addComponent(CameraComponent(orientation: orientation))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
