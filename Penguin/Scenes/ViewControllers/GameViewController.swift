import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNPhysicsContactDelegate {

    @IBOutlet private var sceneView: SCNView!
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
    }
}
