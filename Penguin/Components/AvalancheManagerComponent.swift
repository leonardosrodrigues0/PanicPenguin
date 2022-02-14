import GameplayKit

class AvalancheManagerComponent: GKComponent {
    private enum ZPosition: Int {
        case v1 = -18
        case v2 = -15
        case v3 = -13
        case v4 = -10
        case v5 = -5
        case v0 = -23
        
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
    
    private var completion: (() -> Void)?
    
    private var lastVelocity = GameManager.shared.currentSpeed {
        didSet {
            avalancheAnimator.move(
                to: .init(0, 0, ZPosition(velocity: lastVelocity).rawValue),
                duration: lastVelocity == .v0 ? 0.5 : 0.5,
                completion: self.completion
            )
        }
    }
    
    func coverPlayer(completion: (() -> Void)?) {
        self.completion = completion
        lastVelocity = .v0
    }
    
    override func didAddToEntity() {
        GameManager.shared.avalancheManager = self
        lastVelocity = .v2
    }
        
    override func update(deltaTime seconds: TimeInterval) {
        if lastVelocity != GameManager.shared.currentSpeed {
            lastVelocity = GameManager.shared.currentSpeed
        }
    }
}
