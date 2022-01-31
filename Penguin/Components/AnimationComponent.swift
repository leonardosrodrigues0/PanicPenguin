import GameplayKit

enum ActionType: String {
    case hit
    case idle
    case move
    case rotate
}

class AnimationComponent: GKComponent {
    private var animations: [ActionType: SCNAction]
    private var node: SCNNode?
    
    init(animations: [ActionType: SCNAction]) {
        self.animations = animations
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func run(_ type: ActionType) {
        guard let animation = animations[type]  else {
            return
        }
        
        node?.runAction(animation, forKey: type.rawValue)
    }
    
    func move(by delta: SCNVector3) {
        node?.runAction(.move(by: delta, duration: Config.interval), forKey: ActionType.move.rawValue)
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
