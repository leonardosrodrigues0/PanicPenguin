import SceneKit
import GameplayKit

class TouchControllerComponent: GKComponent {

    var isTouchingScreen: Bool = false
    var touchPosition: CGPoint?
    var frame: CGRect?

    var player: PlayerMovementComponent? {
        return entity?.component(ofType: PlayerMovementComponent.self)
    }

    func handleTouch(at position: CGPoint, in frame: CGRect) {
        guard let player = player else { return }

        let direction = position.x > frame.width/2 ? 1 : -1
        let acceleration = 1.0
        
        player.move(by: Float(acceleration), towards: Float(direction))
    }

    override func update(deltaTime seconds: TimeInterval) {
        if let touchPosition = touchPosition, let frame = frame, isTouchingScreen {
            handleTouch(at: touchPosition, in: frame)
        }
    }

    func setup(_ touchPosition: CGPoint? = nil, _ frame: CGRect? = nil, shouldUpdate isTouchingScreen: Bool = false) {
        if touchPosition != nil { self.touchPosition = touchPosition }
        if frame != nil { self.frame = frame }
        self.isTouchingScreen = isTouchingScreen
    }
}
