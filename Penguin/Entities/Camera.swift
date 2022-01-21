import SceneKit

class Camera: SCNNode {
    override init() {
        super.init()
        self.camera = SCNCamera()
        self.position = SCNVector3(x: 0, y: 25, z: -18)
        self.eulerAngles = SCNVector3(x: -1, y: 0, z: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
