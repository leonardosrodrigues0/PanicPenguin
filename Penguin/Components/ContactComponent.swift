import GameplayKit

class ContactComponent: GKComponent {
    private var obstacles: [PhysicsCategory]
    var action: (PhysicsCategory?) -> Void

    private var storedObstacles: [PhysicsCategory]
    private var storedAction: (PhysicsCategory?) -> Void
    
    /// Implement an `action` to the entity when it hits any `obstacles
    init(with obstacles: [PhysicsCategory], _ action: @escaping (PhysicsCategory?) -> Void) {
        self.obstacles = obstacles
        self.storedObstacles = obstacles
        self.action = action
        self.storedAction = action
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        guard let physicsBody = entity?.component(ofType: PhysicsComponent.self)?.physicsBody else {
            return
        }
        
        physicsBody.contactTestBitMask = PhysicsCategory.bitMask(forCategories: obstacles)
    }
}

extension ContactComponent: ToggleableComponent {
    func disable() {
        obstacles = []
        action = { _ in return }
    }

    func enable() {
        obstacles = storedObstacles
        action = storedAction
    }
}
