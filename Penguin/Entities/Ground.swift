import SceneKit

class Ground: SCNNode {
    override init() {
        super.init()
        let groundGeometry = SCNFloor()
        groundGeometry.reflectivity = 0.5
        let groundMaterial = SCNMaterial()
        groundMaterial.diffuse.contents = UIColor.yellow
        groundGeometry.materials = [groundMaterial]
        self.geometry = groundGeometry
        self.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: groundGeometry, options: nil))
        self.physicsBody!.categoryBitMask = PhysicsCategory.ground.rawValue
        self.physicsBody!.contactTestBitMask = PhysicsCategory.obstacle.rawValue
        self.physicsBody!.collisionBitMask =
            PhysicsCategory.obstacle.rawValue |
            PhysicsCategory.player.rawValue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
