import GameplayKit

/// Defines types of particle effects
enum ParticleEffectType: String {
    case snowTrail
    case avalanche
}

/// Implement an specific type of particle effect
class ParticleEffectComponent: GKComponent {
    private static let particlesAssetPath = "Particles.scnassets/"
    private static let particlesAssetExtension = ".scn"
    
    private let particleNode: SCNNode
    private let attachment: AttachPosition
    
    /// Define the characteristics of the effect
    var particleSystem: SCNParticleSystem
    
    init!(_ effect: ParticleEffectType, at attachment: AttachPosition = .init(.mid, .mid, .mid)) {
        let path = Self.particlesAssetPath + effect.rawValue + Self.particlesAssetExtension
        
        guard
            let scene = SCNScene(named: path),
            let particleNode = scene.rootNode.childNode(withName: "particles", recursively: true),
            let particleSystem = particleNode.particleSystems?.first
        else {
            print("Could not find particle system in \(path)")
            return nil
        }
        
        self.particleNode = particleNode
        self.particleSystem = particleSystem
        self.attachment = attachment
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        guard let node = entity?.component(ofType: GeometryComponent.self)?.node else {
            return
        }

        node.addChildNode(particleNode, at: attachment)
    }
}
