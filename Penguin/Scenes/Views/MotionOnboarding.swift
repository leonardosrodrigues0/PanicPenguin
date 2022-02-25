import UIKit
import SpriteKit
import SceneKit
import Foundation

class MotionOnboarding: SKScene, OverlayableSKScene {

    private let backgroundNode: SKShapeNode
    private let textNode: SKLabelNode

    override init(size: CGSize) {
        backgroundNode = SKShapeNode(rectOf: CGSize(
            width: size.width,
            height: size.height
        ))

        textNode = SKLabelNode()
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
        self.addChild(backgroundNode)
        backgroundNode.fillColor = UIColor.lightGray.withAlphaComponent(0.7)
        backgroundNode.position = CGPoint(
            x: backgroundNode.frame.width / 2,
            y: backgroundNode.frame.height / 2
        )
        backgroundNode.name = "backgroundNode"

        backgroundNode.addChild(textNode)
        textNode.text = "Rotate your device to move"
        textNode.fontSize = CGFloat(40)
        textNode.position = CGPoint(x: 0, y: 0)
        textNode.preferredMaxLayoutWidth = 0.8 * self.frame.width
        textNode.numberOfLines = 0
        textNode.fontName = Self.fontName
        textNode.fontColor = UIColor.black
        textNode.name = "textNode"
    }
}
