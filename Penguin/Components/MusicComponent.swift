//
//  MusicComponent.swift
//  Penguin
//
//  Created by Matheus Vicente on 02/02/22.
//

import SceneKit
import GameplayKit

class MusicComponent: GKComponent {
    private var node: SCNNode?
    
    override func didAddToEntity() {
        guard let node = entity?.component(ofType: GeometryComponent.self)?.node else {
            return
        }
        
        self.node = node

        if let music = SCNAudioSource(named: "JazzRush.mp3") {
            music.volume = 0.04
            let action = SCNAction.playAudio(music, waitForCompletion: true)
            
            let foreverAction = SCNAction.repeatForever(action)
            node.runAction(foreverAction)
        } else {
            print("cannot find musical file")
        }
    }
   
}
