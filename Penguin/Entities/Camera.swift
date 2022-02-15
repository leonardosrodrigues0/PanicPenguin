import SceneKit
import GameplayKit

class Camera: GKEntity {

    override init() {
        super.init()
        let position = SCNVector3(x: 0, y: 5, z: -40)
        let orientation = SCNVector3(
            x: Float(160).toRad,
            y: 0,
            z: Float(180).toRad
        )
        addComponent(GeometryComponent(geometry: nil, position: position))
        addComponent(CameraComponent(orientation: orientation))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
