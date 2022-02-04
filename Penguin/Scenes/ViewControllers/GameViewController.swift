import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class GameViewController: UIViewController {

    @IBOutlet private var sceneView: SCNView!

    lazy private var gameScene: GameScene = buildNewScene()
    lazy internal var hud = Hud(size: CGSize(width: sceneView.frame.width, height: sceneView.frame.height))
    var isInteractingWithHud: Bool = false

    
    private var didGameStart: Bool = false

    private func buildNewScene() -> GameScene {
        let scene = GameScene()
        GameManager.shared.scene = scene
        scene.add(GameManager.shared)
        scene.add(Player())
        scene.add(Ground())
        scene.add(Camera())
        scene.add(Spawner<Tree>())
        scene.add(Spawner<Coin>())
        scene.add(Spawner<SpeedPowerUp>())

        return scene
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.scene = gameScene
        sceneView.delegate = self
        sceneView.isPlaying = true

        GameManager.shared.delegate = self

        DispatchQueue.main.async {
            let alert = self.buildControllerChoiceAlert()
            self.present(alert, animated: true)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        if !didGameStart {
            sceneView.overlaySKScene = hud
            didGameStart = true
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

            GameManager.shared.state = .playing
        }

        let setTouchControllerAction = UIAlertAction(title: "Touch", style: .default) { _ in
            self.gameScene.entities.forEach {
                if let playerController = $0.component(ofType: PlayerMovementComponent.self) {
                    playerController.controller = .touch
                    playerController.entity?.addComponent(TouchControllerComponent())
                }
            }

            GameManager.shared.state = .playing
        }

        alert.addAction(setTouchControllerAction)
        alert.addAction(setMotionControllerAction)

        return alert
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isInteractingWithHud else { return }
        interactWithHud(touches)
        guard GameManager.shared.state == .playing else { return }
        if let position = touches.first?.location(in: sceneView) {
            gameScene.entities.forEach {
                if let touchController = $0.component(ofType: TouchControllerComponent.self) {
                    touchController.setup(position, sceneView.frame, shouldUpdate: true)
                }
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isInteractingWithHud,
              GameManager.shared.state == .playing else { return }

        if let position = touches.first?.location(in: sceneView) {
            gameScene.entities.forEach {
                if let touchController = $0.component(ofType: TouchControllerComponent.self) {
                    touchController.setup(position, sceneView.frame, shouldUpdate: true)
                }
            }
        }

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isInteractingWithHud,
              GameManager.shared.state == .playing else { return }

        gameScene.entities.forEach {
            if let touchController = $0.component(ofType: TouchControllerComponent.self) {
                touchController.setup(shouldUpdate: false)
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isInteractingWithHud,
              GameManager.shared.state == .playing else { return }

        gameScene.entities.forEach {
            if let touchController = $0.component(ofType: TouchControllerComponent.self) {
                touchController.setup(shouldUpdate: false)
            }
        }
    }
}

extension GameViewController: hudDelegate {
}

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard GameManager.shared.state == .playing else { return }
        gameScene.entities.forEach { $0.components.forEach { $0.update(deltaTime: time) } }
    }
}

extension GameViewController: ManagerDelegate {
    func didEnterDeathState() {
        let alert = buildResetGameAlert()

        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

    private func buildResetGameAlert() -> UIAlertController {
        let alert = UIAlertController(title: "You are now deceased.", message: nil, preferredStyle: .actionSheet)

        let resetGameAction = UIAlertAction(title: "Reset Game", style: .default) { _ in

            GameManager.shared.reset()

            let scene = self.buildNewScene()
            self.gameScene = scene
            self.sceneView.scene = scene
            self.viewDidLoad()
        }

        alert.addAction(resetGameAction)

        return alert
    }
}
