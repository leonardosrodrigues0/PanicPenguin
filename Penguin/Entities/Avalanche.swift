import GameplayKit

class Avalanche: GKEntity {
    private var geometryComponent: GeometryComponent = {
        let component = GeometryComponent(
            geometry: SCNBox(width: 50, height: 5, length: 100, chamferRadius: 0)
        )
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemGray4
        component.node.geometry!.materials = [material]
        component.node.pivot = SCNMatrix4MakeTranslation(0, -2.5, -50)
        component.node.position = .init(0, 0, -20)
        return component
    }()
    
    override init() {
        super.init()
        addComponent(geometryComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
