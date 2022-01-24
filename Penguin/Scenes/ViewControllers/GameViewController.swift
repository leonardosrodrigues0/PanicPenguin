import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNPhysicsContactDelegate {

    @IBOutlet private var sceneView: SCNView!
    private var scene = GameScene()

    override func viewDidLoad() {
        super.viewDidLoad()
        scene.physicsWorld.contactDelegate = self
        sceneView.scene = scene
    }

    private func setUpEntities() {
        scene.add(Player())
        scene.add(Ground())
        scene.add(Camera())
    }
}
