import UIKit
import SpriteKit
import SceneKit
import Foundation

class TouchOnboarding: SKScene, OverlayableSKScene {

    private let leftFrameNode: SKShapeNode
    private let rightFrameNode: SKShapeNode
    private let leftArrowNode: SKSpriteNode
    private let rightArrowNode: SKSpriteNode

    override init(size: CGSize) {
        leftFrameNode = SKShapeNode(rectOf: CGSize(
            width: 0.49 * size.width,
            height: size.height
        ))

        rightFrameNode = leftFrameNode.copy() as! SKShapeNode

        leftArrowNode = SKSpriteNode(texture: SKTexture(imageNamed: "leftArrow"))
        rightArrowNode = leftArrowNode.copy() as! SKSpriteNode
        rightArrowNode.zRotation = 180.toRad
        super.init(size: size)
        buildScene()
    }

    override func didMove(to view: SKView) {
        self.isUserInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildScene() {
        self.addChild(leftFrameNode)
        leftFrameNode.fillColor = UIColor.lightGray.withAlphaComponent(0.7)
        leftFrameNode.position = CGPoint(
            x: leftFrameNode.frame.width / 2,
            y: leftFrameNode.frame.height / 2
        )
        leftFrameNode.name = "leftFrameNode"

        self.addChild(rightFrameNode)
        rightFrameNode.fillColor = UIColor.lightGray.withAlphaComponent(0.7)
        rightFrameNode.position = CGPoint(
            x: self.frame.width - rightFrameNode.frame.width / 2,
            y: rightFrameNode.frame.height / 2
        )
        rightFrameNode.name = "rightFrameNode"

        leftFrameNode.addChild(leftArrowNode)
        leftArrowNode.size = CGSize(width: 60, height: 60)
        leftArrowNode.position = CGPoint(x: 0, y: 0)
        leftArrowNode.name = "leftArrowNode"

        rightFrameNode.addChild(rightArrowNode)
        rightArrowNode.size = CGSize(width: 60, height: 60)
        rightArrowNode.position = CGPoint(x: 0, y: 0)
        rightArrowNode.name = "rightArrowNode"
    }
}
