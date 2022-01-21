import SceneKit

class Player: SCNNode {
    override init() {
        super.init()
        self.geometry = SCNBox(width: 3, height: 0.5, length: 3, chamferRadius: 0.2)
        let material = SCNMaterial()
        material.reflective.contents = UIColor.blue
        material.diffuse.contents = UIColor.lightGray
        self.geometry!.materials = [material]
        self.position = SCNVector3(-4, 0.25, -25)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: self, options: nil))
        self.physicsBody!.velocityFactor = SCNVector3(0, 1, 0)
        self.physicsBody!.angularVelocityFactor = SCNVector3(1, 0, 0)
        self.physicsBody!.categoryBitMask = PhysicsCategory.player.rawValue
        self.physicsBody!.collisionBitMask =
            PhysicsCategory.ground.rawValue |
            PhysicsCategory.obstacle.rawValue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
