import GameplayKit

/// Defines commons types of actions to be animated
enum ActionType: String {
    case hit
    case idle
    case move
    case rotate
}

class AnimationComponent: GKComponent {
    private var animations: [ActionType: SCNAction]
    private var node: SCNNode?
    
    init(animations: [ActionType: SCNAction] = [:]) {
        self.animations = animations
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Execute animations defined in the entity's initializer
    func run(_ type: ActionType) {
        guard let animation = animations[type]  else {
            print("Animation of type \(type.rawValue) not defined in entity")
            return
        }
        
        node?.runAction(animation, forKey: type.rawValue)
    }
    
    func move(by delta: SCNVector3) {
        node?.runAction(.move(by: delta, duration: Config.interval), forKey: ActionType.move.rawValue)
    }
    
    func move(to position: SCNVector3, duration: Double = Config.interval) {
        node?.runAction(.move(to: position, duration: duration), forKey: ActionType.move.rawValue)
    }
    
    func rotate(by angle: CGFloat) {
        node?.runAction(.rotateBy(x: 0, y: angle, z: 0, duration: Config.interval), forKey: ActionType.rotate.rawValue)
    }
    
    override func didAddToEntity() {
        guard let node = entity?.component(ofType: GeometryComponent.self)?.node else {
            return
        }
        
        self.node = node
        run(.idle)
    }
}
