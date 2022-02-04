import UIKit
import SpriteKit
import SceneKit
import Foundation

class Hud: SKScene {
    
    let textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "HUD")
    let starIcon: SKSpriteNode
    let pauseIcon: SKSpriteNode
    var starCountText: SKLabelNode
    var speedometerText: SKLabelNode
    
    override init(size: CGSize) {
        self.starIcon = SKSpriteNode(texture: textureAtlas.textureNamed("star"))
        self.pauseIcon = SKSpriteNode(texture: SKTexture.init(image: UIImage(systemName: "pause.fill")!))
        self.starCountText = SKLabelNode(text: "000")
        self.speedometerText = SKLabelNode(text: "000")
        super.init(size: size)
        starIcon.isUserInteractionEnabled = true
        starIcon.childNode(withName: "pauseIcon").
        buildScene()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateLabels(currentScore: GameManager.shared.currentScore, currentSpeed: GameManager.shared.currentSpeed)
    }
    
    func updateLabels(currentScore: Int, currentSpeed: Speed) {
        starCountText.text = "\(currentScore)"
        speedometerText.text = "\(currentSpeed)"
    }
    
    func buildScene() {
        
        starIcon.size = CGSize(width: 20, height: 20)
        starIcon.position = CGPoint(x: 40, y: self.frame.height - 90)
        starIcon.name = "starIcon"
        self.addChild(starIcon)

        starCountText.verticalAlignmentMode = .center
        starCountText.fontSize = CGFloat(16)
        starCountText.position = CGPoint(x: 30, y: 0)
        starCountText.fontName = "AvenirNext-HeavyItalic"
        starCountText.fontColor = UIColor.black
        starCountText.name = "starCountText"
        starIcon.addChild(starCountText)
        
        let speedometerIcon = SKSpriteNode(texture: textureAtlas.textureNamed("speedometer"))
        speedometerIcon.size = CGSize(width: 20, height: 20)
        speedometerIcon.position = CGPoint(x: 70, y: 0)
        speedometerIcon.name = "speedometerIcon"
        starIcon.addChild(speedometerIcon)
        
        speedometerText.verticalAlignmentMode = .center
        speedometerText.fontSize = CGFloat(16)
        speedometerText.position = CGPoint(x: 30, y: 0)
        speedometerText.fontName = "AvenirNext-HeavyItalic"
        speedometerText.fontColor = UIColor.black
        speedometerText.name = "speedometerText"
        speedometerIcon.addChild(speedometerText)
        
        pauseIcon.size = CGSize(width: 20, height: 20)
        pauseIcon.position = CGPoint(x: 140, y: 0)
        pauseIcon.name = "pauseIcon"
        pauseIcon.isUserInteractionEnabled = true
        starIcon.addChild(pauseIcon)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let position = touches.first?.location(in: starIcon) {
            let touchedNode = starIcon.atPoint(position)
            if touchedNode.name == "pauseIcon" {
                print("Pause")
            }
        }
    }
}
