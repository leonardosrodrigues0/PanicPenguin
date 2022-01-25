import UIKit
import QuartzCore
import SceneKit

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
