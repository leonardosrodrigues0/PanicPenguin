import GameplayKit

enum ParticleEffectType: String {
    case snowTrail
}

class ParticleEffectComponent: GKComponent {
    private static let particlesAssetPath = "Particles.scnassets/"
    private static let particlesAssetExtension = ".scn"
    
    let particleSystem: SCNParticleSystem
    
    init!(_ effect: ParticleEffectType) {
        let path = Self.particlesAssetPath + effect.rawValue + Self.particlesAssetExtension
        
        guard
            let scene = SCNScene(named: path),
            let particleNode = scene.rootNode.childNode(withName: "particles", recursively: true),
            let particleSystem = particleNode.particleSystems?.first
        else {
            print("Could not find particle system in \(path)")
            return nil
        }
        
        self.particleSystem = particleSystem
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
