import GameplayKit

class Avalanche: GKEntity {

    static var scene: SCNScene {
        return SCNScene(named: "models.scnassets/Avalanche/Avalanche.scn")!
    }

    static var geometry: SCNGeometry {
        let geometryNode = scene.rootNode.childNode(withName: "Avalanche", recursively: true)
        return geometryNode!.geometry!
    }

    private var geometryComponent: GeometryComponent = {
        let component = GeometryComponent(
            scene: scene)
        // component.node.pivot = SCNMatrix4MakeTranslation(0, -2.5, -50)
        component.node.position = .init(0, -1, -3)
        return component
    }()
    
    override init() {
        super.init()
        addComponent(geometryComponent)
        addComponent(ParticleEffectComponent(.avalanche, at: .init(.mid, .bottom, .front)))
        addComponent(AnimationComponent())
        addComponent(AvalancheManagerComponent())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
