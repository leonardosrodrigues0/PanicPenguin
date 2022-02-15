import GameplayKit
import SceneKit

class Light: GKEntity {

    override init() {
        super.init()
        let position = SCNVector3(x: 10, y: 15, z: -60)
        let orientation = SCNVector3(x: -1, y: 0, z: 0)
        addComponent(GeometryComponent(geometry: nil, position: position))
        addComponent(LightComponent(orientation: orientation))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
