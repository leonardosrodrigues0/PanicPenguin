import SceneKit
import GameplayKit

class Camera: GKEntity {

    override init() {
        super.init()
        let position = SCNVector3(x: 0, y: 25, z: -18)
        let geometryComponent = GeometryComponent(geometry: nil, position: position)
        addComponent(geometryComponent)
        let orientation = SCNVector3(x: -1, y: 0, z: 0)
        addComponent(CameraComponent(orientation: orientation, geometry: geometryComponent))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
