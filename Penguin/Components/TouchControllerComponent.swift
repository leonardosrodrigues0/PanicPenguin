//
//  TouchControllerComponent.swift
//  Penguin
//
//  Created by Erick Manaroulas Felipe on 25/01/22.
//

import SceneKit
import GameplayKit
import CoreMotion

class TouchControllerComponent: GKComponent {

    var isTouchingScreen: Bool = false
    var touchPosition: CGPoint?
    var frame: CGRect?

    var geometry: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }

    func handleTouch(at position: CGPoint, in frame: CGRect) {
        guard let geometry = geometry,
              !geometry.node.hasActions else { return }

        let direction = position.x > frame.width/2 ? 1 : -1

        let acceleration = 1.0
        let dampemFactor = 2.0

        let distance = Float(acceleration / dampemFactor)

        let newPosition = geometry.node.position + SCNVector3Make(distance * Float(direction), 0, 0)

        // Make player respect bounds
        guard newPosition.x >= -5.5 && newPosition.x <= 5.5 else { return }

        let moveAction = SCNAction.move(to: newPosition, duration: Config.interval)

        // Angle is passed in rads, so we convert it and divide by 2 to get about 15 at
        // max distance
        let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(direction) / 180 * .pi / 2, z: 0, duration: Config.interval)

        geometry.node.runAction(rotateAction)
        geometry.node.runAction(moveAction)
    }

    override func update(deltaTime seconds: TimeInterval) {
        if let touchPosition = touchPosition,
           let frame = frame,
           isTouchingScreen {
            handleTouch(at: touchPosition, in: frame)
        }
    }

    func setup(_ touchPosition: CGPoint? = nil, _ frame: CGRect? = nil, shouldUpdate isTouchingScreen: Bool = false) {
        if touchPosition != nil { self.touchPosition = touchPosition }
        if frame != nil { self.frame = frame }
        self.isTouchingScreen = isTouchingScreen
    }
}
