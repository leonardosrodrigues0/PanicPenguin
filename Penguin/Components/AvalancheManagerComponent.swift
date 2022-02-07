import GameplayKit

class AvalancheManagerComponent: GKComponent {
    private enum ZPosition: Int {
        case v1 = -20, v2, v3, v4, v5
        case v0 = -50
        
        init(velocity: Speed) {
            switch velocity {
            case .v0:
                self = .v0
            case .v1:
                self = .v1
            case .v2:
                self = .v2
            case .v3:
                self = .v3
            case .v4:
                self = .v4
            case .v5:
                self = .v5
            }
        }
    }
    
    private var avalancheAnimator: AnimationComponent {
        entity!.component(ofType: AnimationComponent.self)!
    }
    
    private var lastVelocity = GameManager.shared.currentSpeed {
        didSet {
            avalancheAnimator.move(
                to: .init(0, 0, ZPosition(velocity: lastVelocity).rawValue),
                duration: 0.5
            )
        }
    }
        
    // TODO: - lastVelocity não fica em v0 porque a função update deixa de ser chamada quando entra em death state
    override func update(deltaTime seconds: TimeInterval) {
        if lastVelocity != GameManager.shared.currentSpeed {
            lastVelocity = GameManager.shared.currentSpeed
        }
    }
}
