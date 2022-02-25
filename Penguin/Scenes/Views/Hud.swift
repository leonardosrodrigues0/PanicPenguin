import UIKit
import SpriteKit
import SceneKit
import Foundation

class Hud: SKScene, OverlayableSKScene {
    
    private let textureAtlas = SKTextureAtlas(named: "HUD")
    private let pauseTexture: SKTexture
    private let playTexture: SKTexture
    private let rootNode: SKNode
    private let starIcon: SKSpriteNode
    private let starCountText: SKLabelNode
    private let speedometerIcon: SKSpriteNode
    private let speedometerText: SKLabelNode
    private let pauseIcon: SKSpriteNode
    
    override init(size: CGSize) {
        self.rootNode = SKNode()
        self.pauseTexture = textureAtlas.textureNamed("pause")
        self.playTexture = textureAtlas.textureNamed("play")
        self.starIcon = SKSpriteNode(texture: textureAtlas.textureNamed("star"))
        self.starCountText = SKLabelNode(text: "000")
        self.speedometerIcon = SKSpriteNode(texture: textureAtlas.textureNamed("speedometer"))
        self.speedometerText = SKLabelNode(text: "000")
        self.pauseIcon = SKSpriteNode(texture: pauseTexture)
        super.init(size: size)
        buildScene()
    }

    override func didMove(to view: SKView) {
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateLabels(currentScore: GameManager.shared.currentScore, currentSpeed: GameManager.shared.currentSpeed)
    }
    
    private func updateLabels(currentScore: Int, currentSpeed: Speed) {
        starCountText.text = "\(currentScore)"
        speedometerText.text = "\(currentSpeed)"
        // Assure that when size increases, the layout behave properly:
        starCountText.position = CGPoint(x: 30 + starCountText.frame.width / 2, y: -2)
    }
    
    private func buildScene() {
        self.addChild(rootNode)
        rootNode.position = CGPoint(
            x: 0.1 * self.frame.width,
            y: 0.9 * self.frame.height
        )

        rootNode.addChild(starIcon)
        starIcon.size = CGSize(width: 20, height: 20)
        starIcon.position = CGPoint(x: 0, y: 0)
        starIcon.name = "starIcon"

        starIcon.addChild(starCountText)
        starCountText.verticalAlignmentMode = .center
        starCountText.fontSize = CGFloat(25)
        // position updated in `updateLabels`
        starCountText.fontName = Self.fontName
        starCountText.fontColor = UIColor.black
        starCountText.name = "starCountText"

        starIcon.addChild(speedometerIcon)
        speedometerIcon.size = CGSize(width: 20, height: 20)
        speedometerIcon.position = CGPoint(x: 0, y: -40)
        speedometerIcon.name = "speedometerIcon"
        
        speedometerIcon.addChild(speedometerText)
        speedometerText.verticalAlignmentMode = .center
        speedometerText.fontSize = CGFloat(25)
        speedometerText.position = CGPoint(x: 40, y: 0)
        speedometerText.fontName = Self.fontName
        speedometerText.fontColor = UIColor.black
        speedometerText.name = "speedometerText"
        
        rootNode.addChild(pauseIcon)
        pauseIcon.size = CGSize(width: 30, height: 30)
        pauseIcon.position = CGPoint(x: 250, y: 0)
        pauseIcon.name = "pauseIcon"

        let scaleNum = 0.8 * self.frame.width
        let scaleDen = pauseIcon.position.x + (pauseIcon.frame.width / 2)
        rootNode.setScale(scaleNum / scaleDen)
    }
    
    func processTouch(_ touches: Set<UITouch>) {
        if let position = touches.first?.location(in: self) {
            if self.atPoint(position) == pauseIcon {
                GameManager.shared.togglePause { state in
                    switch state {
                    case .paused:
                        self.pauseIcon.texture = playTexture
                    default:
                        self.pauseIcon.texture = pauseTexture
                    }
                }
            }
        }
    }

    func containsInteractableObject(_ touches: Set<UITouch>) -> Bool {
        guard let position = touches.first?.location(in: self) else { return false }
        return self.atPoint(position) == pauseIcon
    }
}
