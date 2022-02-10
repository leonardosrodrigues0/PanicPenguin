import GameplayKit
import SceneKit

enum GameState {
    case menu
    case paused
    case playing
    case dead
}

protocol GameManagerDelegate: AnyObject {
    func didResetGame()
    func didStartGame()
    func didEnterDeathState()
}

class GameManager: GKEntity {

    // MARK: - Singleton logic

    static let shared = GameManager()

    private override init() {
        super.init()
        addComponent(soundManager)
        addComponent(speedManager)
        addComponent(scoreManager)
    }

    // MARK: - Entity components

    let speedManager = SpeedManagerComponent()
    let scoreManager = ScoreManagerComponent()
    let soundManager = AudioManagerComponent()

    // MARK: - Other entities components

    var playerHealth: PlayerHealthComponent?
    var playerMovement: PlayerMovementComponent?
    var avalancheManager: AvalancheManagerComponent?

    // MARK: - Game management

    weak var delegate: GameManagerDelegate?
    weak var scene: GameScene?

    private var lastRendererCall: TimeInterval?
    private var playTime: TimeInterval = 0

    private(set) var state: GameState = .menu {
        didSet {
            print("Game entered \(state) state")
            switch state {
            case .menu:
                scene?.isPaused = true
            case .paused:
                scene?.isPaused = true
            case .playing:
                scene?.isPaused = false
            case .dead:
                avalancheManager?.coverPlayer {
                    self.scene?.isPaused = true
                    print("Game paused")
                }
                delegate?.didEnterDeathState()
            }
        }
    }

    func startGame() {
        guard state == .menu else { return }
        state = .playing
        delegate?.didStartGame()
    }

    func unpause() {
        guard state == .paused else { return }

        // Empty last call so that playTime won't update
        lastRendererCall = nil
        state = .playing
    }

    func pause() {
        if state == .playing {
            state = .paused
        }
    }

    func die() {
        state = .dead
    }

    func togglePause(completion: (GameState) -> Void = { _ in }) {
        switch state {
        case .menu:
            completion(.menu)
        case .paused:
            unpause()
            completion(.playing)
        case .playing:
            pause()
            completion(.paused)
        case .dead:
            completion(.dead)
        }
    }

    func reset() {
        state = .menu
        speedManager.changeSpeed(to: .v2)
        scoreManager.resetScore()
        playTime = 0
        lastRendererCall = nil
        delegate?.didResetGame()
    }

    // MARK: - Access to game information

    var currentSpeed: Speed {
        speedManager.currentSpeed
    }

    var currentScore: Int {
        scoreManager.score
    }

    var coinValue: Int {
        Int(currentSpeed.rawValue * Config.baseCoinValue)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GameManager: SCNSceneRendererDelegate {

    /// Basic scene update method, called by SceneKit every beginning of a new cycle if the scene is not paused.
    /// In this case, this should mean that it won't be called if `state == .paused`.
    /// - Parameters:
    ///   - renderer: Scene renderer.
    ///   - time: Absolute real life time.
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard GameManager.shared.state == .playing else {
            return
        }

        // Do not update playTime if a pause just happened
        if let lastTime = lastRendererCall {
            playTime += time - lastTime

            scene?.entities.forEach { entity in
                entity.update(deltaTime: time - lastTime)
            }
        }

        lastRendererCall = time
    }
}
