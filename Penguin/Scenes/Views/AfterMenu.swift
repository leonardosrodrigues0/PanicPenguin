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

    private static var scoreText: String {
        "Score: \(GameManager.shared.currentScore)"
    }

    override init(size: CGSize) {
        self.iconSize = CGSize(width: 0.6 * size.width, height: 0.15 * size.width)
        self.background = SKSpriteNode(texture: backgroundTexture)
        self.returnGame = SKSpriteNode(texture: returnGameTexture)
        self.finalScore = SKLabelNode(text: Self.scoreText)
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
            y: 0.5 * self.frame.height + 1 * iconSize.height
        )
        returnGame.name = "returnGame"
        self.addChild(returnGame)

        finalScore.verticalAlignmentMode = .center
        finalScore.fontSize = CGFloat(32)
        finalScore.fontName = Self.fontName
        finalScore.fontColor = .white
        finalScore.name = "finalScore"
        finalScore.position = CGPoint(
            x: 0.5 * self.frame.width,
            y: 0.5 * self.frame.height
        )
        self.addChild(finalScore)

        leaderboardIcon.size = iconSize
        leaderboardIcon.position = CGPoint(
            x: 0.5 * self.frame.width,
            y: 0.5 * self.frame.height - 1.5 * iconSize.height
        )
        leaderboardIcon.name = "leaderboardIcon"
        self.addChild(leaderboardIcon)
    }

    func updateOverlay() {
        finalScore.text = Self.scoreText
    }

    override func didMove(to view: SKView) {
        self.isUserInteractionEnabled = false
    }

    func processTouch(_ touches: Set<UITouch>) {
        guard containsInteractableObject(touches) else { return }
        if let position = touches.first?.location(in: self) {
            if returnGame.contains(position) {
                GameManager.shared.reset()
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
