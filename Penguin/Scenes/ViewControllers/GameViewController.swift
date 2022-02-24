import UIKit
import QuartzCore
import SceneKit
import AVFoundation
import SpriteKit

class GameViewController: UIViewController {

    @IBOutlet private var sceneView: SCNView!
    lazy private var gameScene: GameScene = buildNewScene()

    public var backgroundMusicPlayer: AVAudioPlayer?

    private var sceneViewSize: CGSize {
        CGSize(width: sceneView.frame.width, height: sceneView.frame.height)
    }

//    lazy var hud = Hud(size: sceneViewSize)
//    lazy var menu = Menu(size: sceneViewSize)
//    lazy var afterMenu = AfterMenu(size: sceneViewSize)
//    private var controllerOption: MovementManagerType?

//    var overlay: OverlayableSKScene? {
//        didSet {
//            overlay?.updateOverlay()
//            sceneView.overlaySKScene = overlay
//        }
//    }

//    var isInteractingWithOverlay: Bool = false

    func updateScene() {
        gameScene = buildNewScene()
        sceneView.scene = gameScene
    }

    private func buildNewScene() -> GameScene {
        let scene = GameScene()
        GameManager.shared.scene = scene
//        playBackgroundMusic()
        return scene
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.scene = gameScene
        sceneView.delegate = GameManager.shared
        sceneView.isPlaying = true
        GameCenterManager.shared.viewController = self
//        overlay = menu
//        GameManager.shared.delegate = self
    }

    // MARK: - Touches Handling Methods

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard !isInteractingWithOverlay else { return }

        // Keep state from before interaction call
        let state = GameManager.shared.state
//        interactWithOverlay(touches)

        guard
            state == .playing
//            !(overlay?.containsInteractableObject(touches) ?? false)
        else {
            return
        }

        GameManager.shared.playerMovement?.movementManager?.touchesBegan(
            touches,
            with: event,
            view: sceneView
        )
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
//            !isInteractingWithOverlay,
            GameManager.shared.state == .playing
        else {
            return
        }

        GameManager.shared.playerMovement?.movementManager?.touchesMoved(
            touches,
            with: event,
            view: sceneView
        )
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
//            !isInteractingWithOverlay,
            GameManager.shared.state == .playing
        else {
            return
        }

        GameManager.shared.playerMovement?.movementManager?.touchesEnded(
            touches,
            with: event,
            view: sceneView
        )
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
}

//extension GameViewController: OverlayableSKSceneDelegate {}

//extension GameViewController: GameManagerDelegate {
//    func didStartGame() {
//        DispatchQueue.main.async {
//            self.controllerOption = GameManager.shared.playerMovement?.controllerType
//            self.hud.updateRecordLabel()
//            self.overlay = self.hud
//        }
//    }
//
//    func didResetGame() {
//        DispatchQueue.main.async {
//            self.overlay = self.menu
//        }
//    }
//
//    func didEnterDeathState() {
//        DispatchQueue.main.async {
//            self.overlay = self.afterMenu
//            self.sceneView.scene = self.buildNewScene()
//            GameManager.shared.playerMovement?.controllerType = self.controllerOption
//        }
//    }
//
//    public func playBackgroundMusic() {
//        if let url = Bundle.main.url(forResource: "JazzRush", withExtension: ".mp3") {
//            do {
//                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
//            } catch {
//                print("the audio wasn't found")
//            }
//        } else {
//            return print("Could not find file: JazzRush")
//        }
//        if let player = backgroundMusicPlayer {
//            player.volume = 0.06
//            player.numberOfLoops = -1
//            player.prepareToPlay()
//            player.play()
//        } else {
//            print("Could not create audio player")
//        }
//    }
//}
