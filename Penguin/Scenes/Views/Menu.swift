import SpriteKit

class Menu: SKScene, OverlayableSKScene {

    private let iconsSize: CGSize
    private let backgroundTexture = SKTexture(imageNamed: "background")
    private let touchTexture = SKTexture(imageNamed: "touch")
    private let motionTexture = SKTexture(imageNamed: "motion")
    private let leaderboardTexture = SKTexture(imageNamed: "leaderboard")
    private let background: SKSpriteNode
    private let touchIcon: SKSpriteNode
    private let motionIcon: SKSpriteNode
    private let leaderboardIcon: SKSpriteNode

    override init(size: CGSize) {
        self.iconsSize = CGSize(width: 0.6 * size.width, height: 0.15 * size.width)
        self.background = SKSpriteNode(texture: backgroundTexture)
        self.touchIcon = SKSpriteNode(texture: touchTexture)
        self.motionIcon = SKSpriteNode(texture: motionTexture)
        self.leaderboardIcon = SKSpriteNode(texture: leaderboardTexture)

        super.init(size: size)
        buildScene()
    }

    func buildScene() {
        background.size = CGSize(width: 0.9 * self.frame.width, height: 0.4 * self.frame.height)
        background.position = CGPoint(x: 0.5 * self.frame.width, y: 0.5 * self.frame.height)
        background.name = "background"
        self.addChild(background)

        touchIcon.size = iconsSize
        touchIcon.position = CGPoint(
            x: 0.5 * self.frame.width,
            y: 0.5 * self.frame.height + 1.6 * iconsSize.height
        )
        touchIcon.name = "touchIcon"
        self.addChild(touchIcon)

        motionIcon.size = iconsSize
        motionIcon.position = CGPoint(
            x: 0.5 * self.frame.width,
            y: 0.5 * self.frame.height + 0.4 * iconsSize.height
        )
        motionIcon.name = "motionIcon"
        self.addChild(motionIcon)

        leaderboardIcon.size = iconsSize
        leaderboardIcon.position = CGPoint(
            x: 0.5 * self.frame.width,
            y: 0.5 * self.frame.height - 1.6 * iconsSize.height
        )
        leaderboardIcon.name = "leaderboardIcon"
        self.addChild(leaderboardIcon)
    }

    override func didMove(to view: SKView) {
        self.isUserInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func processTouch(_ touches: Set<UITouch>) {
        guard containsInteractableObject(touches) else { return }
        if let position = touches.first?.location(in: self) {
            if motionIcon.contains(position) {
                GameManager.shared.playerMovement?.controllerType = .motion
                GameManager.shared.startGame()
            } else if touchIcon.contains(position) {
                GameManager.shared.playerMovement?.controllerType = .touch
                GameManager.shared.startGame()
            } else if leaderboardIcon.contains(position) {
                // Leaderboard access here
                GameCenterManager.shared.displayLeaderboard(.test)
            }
        }
    }

    func containsInteractableObject(_ touches: Set<UITouch>) -> Bool {
        guard let position = touches.first?.location(in: self) else { return false }
        return motionIcon.contains(position) ||
            touchIcon.contains(position) ||
            leaderboardIcon.contains(position)
    }
}
