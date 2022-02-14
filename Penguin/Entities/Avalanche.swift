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
//        addComponent(ParticleEffectComponent(.avalanche, at: .init(.mid, .bottom, .front)))
        addComponent(AnimationComponent(animations: [
            .idle: .repeatForever(
                .group([
                    .sequence([
                        .scale(by: 21/20, duration: 1),
                        .scale(by: 20/21, duration: 1)
                    ]),
                    .sequence([
                        .rotate(by: 3.toRad, around: .init(0, 0, 1), duration: 0.5),
                        .rotate(by: (-6).toRad, around: .init(0, 0, 1), duration: 1),
                        .rotate(by: 3.toRad, around: .init(0, 0, 1), duration: 0.5)
                    ])
                ])
            )
        ]))
        addComponent(AvalancheManagerComponent())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
