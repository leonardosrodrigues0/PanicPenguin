import SceneKit
import GameplayKit

class LightComponent: GKComponent {
    
    private let light: SCNLight
    private let orientation: SCNVector3

    init(orientation: SCNVector3) {
        self.light = SCNLight()
        self.orientation = orientation
        super.init()
        configLight()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configOrientation(orientation: SCNVector3) -> SCNVector3 {
        var newOrientation: SCNVector3 = orientation
        newOrientation.x += 10
        newOrientation.y += 100
        newOrientation.z += 50
        return newOrientation
    }
    
    func configLight() {
        light.type = .omni
        light.intensity = CGFloat(10000)
        if #available(iOS 13.0, *) {
            light.color = UIColor.systemGray
        }
    }
    
    override func didAddToEntity() {
        guard let node = entity?.component(ofType: GeometryComponent.self)?.node else {
            return
        }
        node.eulerAngles = orientation
        node.light = light
    }
}
