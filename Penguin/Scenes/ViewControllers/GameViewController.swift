import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNPhysicsContactDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHierarchy()
        sceneView.scene = scene
        scene.physicsWorld.contactDelegate = self
    }

    private func setUpHierarchy() {
        scene.rootNode.addChildNode(camera)
        scene.rootNode.addChildNode(player)
        scene.rootNode.addChildNode(ground)
    }

    private var scene: SCNScene = GameScene()
    lazy private var sceneView: SCNView = self.view as! SCNView
    private var camera: SCNNode = Camera()
    private var ground: SCNNode = Ground()
    private var player: SCNNode = Player()
}
