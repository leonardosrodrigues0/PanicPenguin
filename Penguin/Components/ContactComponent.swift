import GameplayKit

class ContactComponent: GKComponent {
    private let obstacles: [PhysicsCategory]
    var action: (PhysicsCategory?) -> Void
    
    /// Implement an `action` to the entity when it hits any `obstacles
    init(with obstacles: [PhysicsCategory], _ action: @escaping (PhysicsCategory?) -> Void) {
        self.obstacles = obstacles
        self.action = action
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
