import SceneKit
import GameplayKit

class MusicComponent: GKComponent {
    private var node: SCNNode? {
        entity?.component(ofType: GeometryComponent.self)?.node
    }
    
    func hitObstacleSound() {
        if GameManager.shared.currentSpeed == .v1 {
            if let soundEffect = SCNAudioSource(named: "Pinguim-dead.mp3") {
                let action = SCNAction.playAudio(soundEffect, waitForCompletion: false)
                node?.runAction(action)
            } else {
                print("Sound Effect of pinguim died wasn't find")
            }
        } else {
            if let soundEffect = SCNAudioSource(named: "Pinguim-strike.mp3" ) {
                let action = SCNAction.playAudio(soundEffect, waitForCompletion: false)
                node?.runAction(action)
            } else {
                print("Sound Effect of pinguim strike wasn't find")
            }
        }
    }
    
    func powerUpSound() {
        if let soundEffect = SCNAudioSource(named: "Pinguim-powerUp.mp3") {
            let action = SCNAction.playAudio(soundEffect, waitForCompletion: false)
            node?.runAction(action)
        } else {
            print("Sound Effect of powerUp wasn't found")
        }
    }
    
    func coinSound() {
        if let soundEffect = SCNAudioSource(named: "Pinguim-coin.mp3") {
            let action = SCNAction.playAudio(soundEffect, waitForCompletion: false)
            node?.runAction(action)
        } else {
            print("Sound Effect of pinguim died wasn't find")
        }
    }
}
