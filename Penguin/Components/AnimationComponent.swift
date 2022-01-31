import GameplayKit

enum ActionType {
    case shake
    case scale
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
        
        node?.runAction(animation)
    }
    
    override func didAddToEntity() {
        guard let node = entity?.component(ofType: GeometryComponent.self)?.node else {
            return
        }
        
        self.node = node
    }
}
