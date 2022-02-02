import GameplayKit

enum ParticleEffectType: String {
    case snowTrail
}

class ParticleEffectComponent: GKComponent {
    private static let particlesAssetPath = "Particles.scnassets/"
    private static let particlesAssetExtension = ".scn"
    
    let particleSystem: SCNParticleSystem
    
    init(_ effect: ParticleEffectType) {
        let scene = SCNScene(named: Self.particlesAssetPath + effect.rawValue + Self.particlesAssetExtension)
        particleSystem = (scene!.rootNode.childNode(withName: "particles", recursively: true)?.particleSystems?.first)!
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        guard let node = entity?.component(ofType: GeometryComponent.self)?.node else {
            return
        }
        
        node.addParticleSystem(particleSystem)
    }
}
