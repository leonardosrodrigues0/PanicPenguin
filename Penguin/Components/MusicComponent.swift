import SceneKit
import GameplayKit

class MusicComponent: GKComponent {
    private var node: SCNNode? {
        entity?.component(ofType: GeometryComponent.self)?.node
    }

    override func didAddToEntity() {
        if let music = SCNAudioSource(named: "JazzRush.mp3") {
            music.volume = 0.04
            let action = SCNAction.playAudio(music, waitForCompletion: true)
            
            let foreverAction = SCNAction.repeatForever(action)
            node?.runAction(foreverAction)
        } else {
            print("cannot find musical file")
        }
    }
}
