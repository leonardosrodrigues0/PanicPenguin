import UIKit
import QuartzCore
import SceneKit
import AVFoundation
import SpriteKit

class GameViewController: UIViewController {

    @IBOutlet private var sceneView: SCNView! {
        didSet {
            GameManager.shared.overlayManager.sceneView = sceneView
        }
    }

    lazy private var gameScene: GameScene = buildNewScene()

    public var backgroundMusicPlayer: AVAudioPlayer?
    
    internal var controllerOption: MovementManagerType?

    private func buildNewScene() -> GameScene {
        let scene = GameScene()
        GameManager.shared.scene = scene
        playBackgroundMusic()
        return scene
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.scene = gameScene
        sceneView.delegate = GameManager.shared
        sceneView.isPlaying = true
        GameCenterManager.shared.viewController = self
        GameManager.shared.delegate = self
    }

    // MARK: - Touches Handling Methods

    var isInteractingWithOverlay: Bool {
        GameManager.shared.overlayManager.isInteractingWithOverlay
    }

    func containsInteractableObject(_ touches: Set<UITouch>) -> Bool {
        GameManager.shared.overlayManager.overlay?.containsInteractableObject(touches) ?? false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isInteractingWithOverlay else { return }

        // Keep state from before interaction call
        let state = GameManager.shared.state
        GameManager.shared.overlayManager.interactWithOverlay(touches)

        guard
            state == .playing,
            !containsInteractableObject(touches)
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

    func playBackgroundMusic() {
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

extension GameViewController: GameManagerDelegate {

    func didEnterDeathState() {
        DispatchQueue.main.async {
            self.sceneView.scene = self.buildNewScene()
        }
    }
}
