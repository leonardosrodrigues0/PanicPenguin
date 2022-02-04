import SceneKit
import GameplayKit

class LightComponent: GKComponent {
    
    private let light: SCNLight
    private let orientation: SCNVector3

    init(orientation: SCNVector3) {
        self.light = SCNLight()
        self.orientation = orientation
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configLight() {
        light.type = .ambient
        if #available(iOS 13.0, *) {
            light.color = CGColor(red: 253, green: 184, blue: 19, alpha: 1)
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
