import UIKit
import SpriteKit
import SceneKit
import Foundation

class Hud: SKScene, OverlayableSKScene {
    
    let textureAtlas = SKTextureAtlas(named: "HUD")
    let pauseTexture = SKTexture(image: UIImage(systemName: "pause.fill")!)
    let playTexture = SKTexture(image: UIImage(systemName: "play.fill")!)
    let starIcon: SKSpriteNode
    let pauseIcon: SKSpriteNode
    var starCountText: SKLabelNode
    var speedometerText: SKLabelNode
    
    override init(size: CGSize) {
        self.starIcon = SKSpriteNode(texture: textureAtlas.textureNamed("star"))
        self.pauseIcon = SKSpriteNode(texture: pauseTexture)
        self.starCountText = SKLabelNode(text: "000")
        self.speedometerText = SKLabelNode(text: "000")
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
        pauseIcon.position = CGPoint(x: 180, y: self.frame.height - 90)
        pauseIcon.name = "pauseIcon"
        self.addChild(pauseIcon)
    }
    
    func processTouch(_ touches: Set<UITouch>) {
        if let position = touches.first?.location(in: self) {
            if pauseIcon.contains(position) {
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
        return pauseIcon.contains(position)
    }
}
