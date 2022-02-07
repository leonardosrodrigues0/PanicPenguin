import SceneKit
import GameplayKit

enum SoundEffectOrigin: String {
    case hit = "Pinguim-strike.mp3"
    case death = "Pinguim-dead.mp3"
    case coin = "Pinguim-coin.mp3"
    case powerUp = "Pinguim-powerUp.mp3"
    
    static func fromCategory(_ physics: PhysicsCategory?) -> SoundEffectOrigin? {
        switch physics {
        case .obstacle:
            return GameManager.shared.currentSpeed == .v0 ? .death : .hit
        case .coin:
            return .coin
        case .powerUp:
            return .powerUp
        default:
            return nil
        }
    }
}
                    
class AudioManagerComponent: GKComponent {
    
    func triggerSoundEffect(_ origin: SoundEffectOrigin?, fromEntity entity: GKEntity) {
        guard let node = node(from: entity),
              let origin = origin,
              let soundEffect = SCNAudioSource(named: origin.rawValue)
        else {
            print("Failure trigger Sound effect")
            return
        }
        let action = SCNAction.playAudio(soundEffect, waitForCompletion: false)
        node.runAction(action)
    }
    
    private func node(from entity: GKEntity) -> SCNNode? {
       return entity.component(ofType: GeometryComponent.self)?.node
    }
}
