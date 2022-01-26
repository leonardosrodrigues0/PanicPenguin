import GameplayKit
import SceneKit

enum GameState {
    case paused
    case playing
}

class GameManager: GKEntity {

    static let shared = GameManager()

    weak var scene: GameScene?
    let speedManager = SpeedManagerComponent()
    let scoreManager = ScoreManagerComponent()

    var currentSpeed: Speed {
        speedManager.currentSpeed
    }

    var currentScore: Int {
        scoreManager.score
    }

    var state: GameState = .paused {
       didSet {
           switch state {
           case .paused:
               scene?.pause()
           case .playing:
               scene?.play()
           }
       }
    }

    var playerHealth: PlayerHealthComponent? {
        didSet {
            speedManager.playerHealth = playerHealth
        }
    }

    private override init() {
        super.init()
        addComponent(speedManager)
        addComponent(scoreManager)
    }

    func toggleState() {
        switch state {
        case .paused:
            state = .playing
        case .playing:
            state = .paused
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
