import SpriteKit
import SceneKit
import Foundation

class Hud {
    
    var starCountText: SKLabelNode = SKLabelNode(text: "000")
    var speedometerText: SKLabelNode = SKLabelNode(text: "000")
    let pauseIcon: SKSpriteNode = SKSpriteNode(texture: SKTexture.init(image: UIImage(systemName: "pause.fill")!))
    
    func buildHud(sceneWidth: CGFloat, sceneHeight: CGFloat) -> SKScene {

        let overlayScene = SKScene(size: CGSize(width: sceneWidth, height: sceneHeight))
        let textureAtlas = SKTextureAtlas(named: "HUD")
        
        let starIcon = SKSpriteNode(texture: textureAtlas.textureNamed("star"))
        starIcon.size = CGSize(width: 20, height: 20)
        starIcon.position = CGPoint(x: 40, y: sceneHeight - 90)
        starIcon.name = "starIcon"
        
        starCountText.verticalAlignmentMode = .center
        starCountText.fontSize = CGFloat(16)
        starCountText.position = CGPoint(x: 30, y: 0)
        starCountText.fontName = "AvenirNext-HeavyItalic"
        starCountText.fontColor = UIColor.black
        starCountText.name = "starCountText"
        
        let speedometerIcon = SKSpriteNode(texture: textureAtlas.textureNamed("speedometer"))
        speedometerIcon.size = CGSize(width: 20, height: 20)
        speedometerIcon.position = CGPoint(x: 70, y: 0)
        speedometerIcon.name = "speedometerIcon"
        
        speedometerText.verticalAlignmentMode = .center
        speedometerText.fontSize = CGFloat(16)
        speedometerText.position = CGPoint(x: 30, y: 0)
        speedometerText.fontName = "AvenirNext-HeavyItalic"
        speedometerText.fontColor = UIColor.black
        speedometerText.name = "speedometerText"
        
        pauseIcon.size = CGSize(width: 20, height: 20)
        pauseIcon.position = CGPoint(x: 140, y: 0)
        pauseIcon.name = "pauseIcon"
        
        speedometerIcon.addChild(speedometerText)
        starIcon.addChild(starCountText)
        starIcon.addChild(speedometerIcon)
        starIcon.addChild(pauseIcon)
        overlayScene.addChild(starIcon)
        
        return overlayScene
    }
    
    func updateLabels(currentScore: Int, currentSpeed: Speed) {
        starCountText.text = "\(currentScore)"
        speedometerText.text = "\(currentSpeed)"
    }
    
    func getPauseIconWidth() -> CGFloat {
        return pauseIcon.frame.width
    }
    
    func getPauseIconHeight() -> CGFloat {
        return pauseIcon.frame.height
    }
    
}
