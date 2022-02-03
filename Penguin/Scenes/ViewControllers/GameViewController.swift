import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class GameViewController: UIViewController {

    @IBOutlet private var sceneView: SCNView!

//    @IBAction private func pause() {
//        GameManager.shared.togglePause()
//    }

    lazy private var gameScene: GameScene = buildNewScene()
    private var hud: Hud = Hud()
    
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
        
        // TODO: Remove timer
        Timer.scheduledTimer(withTimeInterval: Config.interval, repeats: true) { _ in
            self.hud.updateLabels(currentScore: GameManager.shared.currentScore, currentSpeed: GameManager.shared.currentSpeed)
        }
    }
    
    override func viewDidLayoutSubviews() {
        if !didGameStart {
            sceneView.overlaySKScene = hud.buildHud(sceneWidth: sceneView.frame.width, sceneHeight: sceneView.frame.height)
            sceneView.overlaySKScene?.isUserInteractionEnabled = false
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
        let touch = touches.first
        let touchLocation = touch!.location(in: sceneView)
        
        let pauseIconLocation = (sceneView.overlaySKScene?.childNode(withName: "starIcon")!.childNode(withName: "pauseIcon")!.position)!
        let starIconLocation = (sceneView.overlaySKScene?.childNode(withName: "starIcon")!.position)!

        let sumStarPause = CGPoint(x: starIconLocation.x + pauseIconLocation.x, y: sceneView.frame.height - starIconLocation.y)
        
        if touchLocation.x > sumStarPause.x - hud.getPauseIconWidth() / 2 &&
            touchLocation.x < sumStarPause.x + hud.getPauseIconWidth() / 2 &&
            touchLocation.y > sumStarPause.y - hud.getPauseIconHeight() / 2 &&
            touchLocation.y < sumStarPause.y + hud.getPauseIconHeight() / 2 {
            GameManager.shared.togglePause()
        }
        
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
