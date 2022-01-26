import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNPhysicsContactDelegate {

    @IBOutlet private var sceneView: SCNView!
    @IBOutlet private var scoreLabel: UILabel!

    @IBAction private func pause() {
        gameScene.togglePaused()
    }

    private var gameScene: GameScene = {
        let scene = GameScene()
        scene.add(Player())
        scene.add(Ground())
        scene.add(Camera())
        return scene
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        gameScene.physicsWorld.contactDelegate = self
        sceneView.scene = gameScene
        sceneView.delegate = self

        DispatchQueue.main.async {
            let alert = self.buildControllerChoiceAlert()
            self.present(alert, animated: true)
            self.gameScene.play()
        }

        Timer.scheduledTimer(withTimeInterval: Config.scoreUpdateInterval, repeats: true) { _ in
            self.scoreLabel.text = "\(self.gameScene.score)"
        }
    }

    func buildControllerChoiceAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Choose your Controller Scheme", message: nil, preferredStyle: .actionSheet)

        let setMotionControllerAction = UIAlertAction(title: "Motion", style: .default) { _ in
            self.gameScene.entities.forEach {
                if let playerController = $0.component(ofType: PlayerMovementComponent.self) {
                    playerController.controller = .motion
                    playerController.entity?.addComponent(MotionControllerComponent())
                }
            }
        }

        let setTouchControllerAction = UIAlertAction(title: "Touch", style: .default) { _ in
            self.gameScene.entities.forEach {
                if let playerController = $0.component(ofType: PlayerMovementComponent.self) {
                    playerController.controller = .touch
                    playerController.entity?.addComponent(TouchControllerComponent())
                }
            }
        }

        alert.addAction(setTouchControllerAction)
        alert.addAction(setMotionControllerAction)

        return alert
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let position = touches.first?.location(in: sceneView) {
            gameScene.entities.forEach {
                if let touchController = $0.component(ofType: TouchControllerComponent.self) {
                    touchController.setup(position, sceneView.frame, shouldUpdate: true)
                }
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let position = touches.first?.location(in: sceneView) {
            gameScene.entities.forEach {
                if let touchController = $0.component(ofType: TouchControllerComponent.self) {
                    touchController.setup(position, sceneView.frame, shouldUpdate: true)
                }
            }
        }

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameScene.entities.forEach {
            if let touchController = $0.component(ofType: TouchControllerComponent.self) {
                touchController.setup(shouldUpdate: false)
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameScene.entities.forEach {
            if let touchController = $0.component(ofType: TouchControllerComponent.self) {
                touchController.setup(shouldUpdate: false)
            }
        }
    }
}

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // without this scene doesnt run update???
        // TODO: Fix this
        sceneView.isPlaying = true
        gameScene.entities.forEach { $0.components.forEach { $0.update(deltaTime: time) } }
    }
}
