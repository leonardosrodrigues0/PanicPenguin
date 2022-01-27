import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class GameViewController: UIViewController, SCNPhysicsContactDelegate {

    @IBOutlet private var sceneView: SCNView!
    
    lazy var gameScene: GameScene = scene as! GameScene
    
    private var scene: SCNScene = {
        let scene = GameScene()
        scene.add(Player())
        scene.add(Ground())
        scene.add(Camera())
        
        return scene
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        scene.physicsWorld.contactDelegate = self
        sceneView.scene = scene
        sceneView.delegate = self

        DispatchQueue.main.async {
            let alert = self.buildControllerChoiceAlert()
            self.present(alert, animated: true)
        }
        
        sceneView.overlaySKScene = buildHud()
    }

    func buildHud() -> SKScene {
        let overlayScene = SKScene(size: CGSize(width: sceneView.frame.width, height: sceneView.frame.height))
        let textureAtlas = SKTextureAtlas(named: "HUD")
        
        let starIcon = SKSpriteNode(texture: textureAtlas.textureNamed("star"))
        starIcon.size = CGSize(width: 20, height: 20)
        starIcon.position = CGPoint(x: 40, y: sceneView.frame.height - 90)
        
        let starCountText = SKLabelNode(text: "000")
        starCountText.verticalAlignmentMode = .center
        starCountText.fontSize = CGFloat(16)
        starCountText.position = CGPoint(x: 30, y: 0)
        starCountText.fontName = "AvenirNext-HeavyItalic"
        starCountText.fontColor = UIColor.black
        
        let speedometerIcon = SKSpriteNode(texture: textureAtlas.textureNamed("speedometer"))
        speedometerIcon.size = CGSize(width: 20, height: 20)
        speedometerIcon.position = CGPoint(x: 70, y: 0)
        
        let speedometerText = SKLabelNode(text: "000")
        speedometerText.verticalAlignmentMode = .center
        speedometerText.fontSize = CGFloat(16)
        speedometerText.position = CGPoint(x: 30, y: 0)
        speedometerText.fontName = "AvenirNext-HeavyItalic"
        speedometerText.fontColor = UIColor.black
        
        let pauseIcon = SKSpriteNode(texture: SKTexture.init(image: UIImage(systemName: "pause.fill")!))
        
        pauseIcon.size = CGSize(width: 15, height: 15)
        pauseIcon.position = CGPoint(x: 140, y: 0)
        
        speedometerIcon.addChild(speedometerText)
        starIcon.addChild(starCountText)
        starIcon.addChild(speedometerIcon)
        starIcon.addChild(pauseIcon)
        overlayScene.addChild(starIcon)
        
        return overlayScene
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
        
        guard let scene = scene as? GameScene else { return }
        scene.entities.forEach { $0.components.forEach { $0.update(deltaTime: time); print($0) } }
    }
}
