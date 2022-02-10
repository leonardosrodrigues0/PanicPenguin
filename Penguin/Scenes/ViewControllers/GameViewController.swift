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

    lazy var hud = Hud(size: sceneViewSize)
    lazy var menu = Menu(size: sceneViewSize)

    var overlay: OverlayableSKScene? {
        didSet {
            sceneView.overlaySKScene = overlay
        }
    }

    var isInteractingWithOverlay: Bool = false

    private func buildNewScene() -> GameScene {
        let scene = GameScene()
        GameManager.shared.scene = scene
        scene.add(GameManager.shared)
        scene.add(Player())
        scene.add(Ground())
        scene.add(Camera())
        scene.add(Light())
        scene.add(Avalanche())
        scene.add(Spawner<Tree>())
        scene.add(Spawner<Coin>())
        scene.add(Spawner<SpeedPowerUp>())
        playBackgroundMusic()

        return scene
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.scene = gameScene
        sceneView.delegate = GameManager.shared
        sceneView.isPlaying = true
        overlay = menu
        GameManager.shared.delegate = self
    }

    // MARK: - Touches Handling Methods

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isInteractingWithOverlay else { return }

        // Keep state from before interaction call
        let state = GameManager.shared.state
        interactWithOverlay(touches)

        guard
            state == .playing,
            !(overlay?.containsInteractableObject(touches) ?? false)
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
            !isInteractingWithOverlay,
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
            !isInteractingWithOverlay,
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

extension GameViewController: OverlayableSKSceneDelegate {}

extension GameViewController: GameManagerDelegate {
    func didStartGame() {
        overlay = hud
    }

    func didResetGame() {
        overlay = menu
    }

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

    public func playBackgroundMusic() {
        if let url = Bundle.main.url(forResource: "JazzRush", withExtension: ".mp3") {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            } catch {
                print("the audio wasn't found")
            }
        } else {
            return print("Could not find file: JazzRush")
        }
        if let player = backgroundMusicPlayer {
            player.volume = 0.06
            player.numberOfLoops = -1
            player.prepareToPlay()
            player.play()
        } else {
            print("Could not create audio player")
        }
    }
}
