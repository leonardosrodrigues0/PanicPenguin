import SpriteKit

class AfterMenu: SKScene, OverlayableSKScene {

    private let iconSize: CGSize
    private let backgroundTexture = SKTexture(imageNamed: "background")
    private let returnGameTexture = SKTexture(imageNamed: "return")
    private var finalScore: SKLabelNode
    private let leaderboardTexture = SKTexture(imageNamed: "leaderboard")

    private let background: SKSpriteNode
    private let returnGame: SKSpriteNode
    private let leaderboardIcon: SKSpriteNode

    override init(size: CGSize) {
        self.iconSize = CGSize(width: 0.9 * size.width, height: 0.09 * size.height)
        self.background = SKSpriteNode(texture: backgroundTexture)
        self.returnGame = SKSpriteNode(texture: returnGameTexture)
        self.finalScore = SKLabelNode(text: "\(GameManager.shared.currentScore)")
        self.leaderboardIcon = SKSpriteNode(texture: leaderboardTexture)

        super.init(size: size)
        buildScene()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func buildScene() {
        background.size = CGSize(width: 0.95 * self.frame.width, height: 0.4 * self.frame.height)
        background.position = CGPoint(x: 0.5 * self.frame.width, y: 0.5 * self.frame.height)
        background.name = "background"
        self.addChild(background)

        returnGame.size = iconSize
        returnGame.position = CGPoint(
            x: 0.5 * self.frame.width,
            y: 0.5 * self.frame.height + iconSize.height
        )
        returnGame.name = "returnGame"
        self.addChild(returnGame)

        finalScore.verticalAlignmentMode = .center
        finalScore.fontSize = CGFloat(32)
        finalScore.fontName = "AvenirNext-HeavyItalic"
        finalScore.fontColor = .black
        finalScore.name = "finalScore"
        finalScore.position = CGPoint(
            x: 0.5 * self.frame.width,
            y: 0.5 * self.frame.height
        )
        self.addChild(finalScore)

        leaderboardIcon.size = iconSize
        leaderboardIcon.position = CGPoint(
            x: 0.5 * self.frame.width,
            y: 0.5 * self.frame.height - iconSize.height
        )
        leaderboardIcon.name = "leaderboardIcon"
        self.addChild(leaderboardIcon)
    }

    override func didMove(to view: SKView) {
        self.isUserInteractionEnabled = false
    }

    func processTouch(_ touches: Set<UITouch>) {
        guard containsInteractableObject(touches) else { return }
        if let position = touches.first?.location(in: self) {
            if returnGame.contains(position) {
                let gameMode = GameManager.shared.playerMovement?.controllerType
                GameManager.shared.reset()
                GameManager.shared.playerMovement?.controllerType = gameMode
                GameManager.shared.startGame()
            } else if leaderboardIcon.contains(position) {
                GameCenterManager.shared.displayLeaderboard(.test)
            }
        }
    }

    func containsInteractableObject(_ touches: Set<UITouch>) -> Bool {
        guard let position = touches.first?.location(in: self) else { return false }
        return leaderboardIcon.contains(position) ||
            returnGame.contains(position)
    }

}