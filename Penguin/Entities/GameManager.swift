import GameplayKit
import SceneKit

enum GameState {
    case paused
    case playing
    case dead
}

protocol GameManagerDelegate: AnyObject {
    func didEnterDeathState()
}

class GameManager: GKEntity {

    static let shared = GameManager()

    var state: GameState = .paused {
        didSet {
            switch state {
            case .paused:
                scene?.isPaused = true
            case .playing:
                scene?.isPaused = false
            case .dead:
                avalancheManager?.coverPlayer()
                delegate?.didEnterDeathState()
            }
        }
    }

    weak var delegate: GameManagerDelegate?

    weak var scene: GameScene?

    let speedManager = SpeedManagerComponent()
    let scoreManager = ScoreManagerComponent()

    var playerHealth: PlayerHealthComponent?
    var playerMovement: PlayerMovementComponent?
    var avalancheManager: AvalancheManagerComponent?

    var currentSpeed: Speed {
        speedManager.currentSpeed
    }

    var currentScore: Int {
        scoreManager.score
    }

    var coinValue: Int {
        Int(currentSpeed.rawValue) * Config.baseCoinValue
    }

    private override init() {
        super.init()
        addComponent(speedManager)
        addComponent(scoreManager)
    }

    func togglePause() {
        switch state {
        case .paused:
            state = .playing
        case .playing:
            state = .paused
        case .dead:
            return
        }
    }

    func reset() {
        state = .paused
        speedManager.changeSpeed(to: .v2)
        scoreManager.resetScore()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
