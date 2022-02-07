import UIKit
import QuartzCore
import SceneKit
import AVFoundation

class GameViewController: UIViewController {
    
    @IBOutlet private var sceneView: SCNView!
    @IBOutlet private var scoreLabel: UILabel!
    @IBOutlet private var speedLabel: UILabel!
    
    @IBAction private func pause() {
        GameManager.shared.togglePause()
    }
    
    lazy private var gameScene: GameScene = buildNewScene()
    public var backgroundMusicPlayer: AVAudioPlayer?
    
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
        playBackgroundMusic()
        
        return scene
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.scene = gameScene
        sceneView.delegate = GameManager.shared
        sceneView.isPlaying = true
        
        GameManager.shared.delegate = self
        
        DispatchQueue.main.async {
            let alert = self.buildControllerChoiceAlert()
            self.present(alert, animated: true)
        }
        
        Timer.scheduledTimer(withTimeInterval: Config.interval, repeats: true) { _ in
            self.scoreLabel.text = "\(GameManager.shared.currentScore)"
            self.speedLabel.text = "\(GameManager.shared.currentSpeed)"
        }
    }
    
    func buildControllerChoiceAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Choose your Controller Scheme", message: nil, preferredStyle: .actionSheet)
        
        let setMotionControllerAction = UIAlertAction(title: "Motion", style: .default) { _ in
            GameManager.shared.playerMovement?.controllerType = .motion
            GameManager.shared.unpause()
        }
        
        let setTouchControllerAction = UIAlertAction(title: "Touch", style: .default) { _ in
            GameManager.shared.playerMovement?.controllerType = .touch
            GameManager.shared.unpause()
        }
        
        alert.addAction(setTouchControllerAction)
        alert.addAction(setMotionControllerAction)
        
        return alert
    }
    
    // MARK: - Touches Handling Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        GameManager.shared.playerMovement?.movementManager?.touchesBegan(
            touches,
            with: event,
            view: sceneView
        )
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        GameManager.shared.playerMovement?.movementManager?.touchesEnded(
            touches,
            with: event,
            view: sceneView
        )
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        GameManager.shared.playerMovement?.movementManager?.touchesMoved(
            touches,
            with: event,
            view: sceneView
        )
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
}

extension GameViewController: GameManagerDelegate {
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
