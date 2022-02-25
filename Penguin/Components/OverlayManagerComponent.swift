import GameplayKit

class OverlayManagerComponent: GKComponent, OverlayableSKSceneDelegate {
    var isInteractingWithOverlay: Bool = false

    private var scene: GameScene? {
        let manager = entity as? GameManager
        return manager?.scene
    }

    weak var sceneView: SCNView? {
        didSet {
            if let size = sceneView?.frame.size {
                initOverlays(sceneViewSize: size)
            }
        }
    }

    private var hud: Hud?
    private var menu: Menu?
    private var afterMenu: AfterMenu?
    private var touchOnboarding: TouchOnboarding?
    private var motionOnboarding: MotionOnboarding?

    var overlay: OverlayableSKScene? {
        didSet {
            overlay?.updateOverlay()
            DispatchQueue.main.async {
                self.sceneView?.overlaySKScene = self.overlay
            }
        }
    }

    private func initOverlays(sceneViewSize: CGSize) {
        hud = Hud(size: sceneViewSize)
        menu = Menu(size: sceneViewSize)
        afterMenu = AfterMenu(size: sceneViewSize)
        touchOnboarding = TouchOnboarding(size: sceneViewSize)
        motionOnboarding = MotionOnboarding(size: sceneViewSize)
        overlay = menu
    }

    func activateHud() {
        overlay = hud
    }

    func activateMenu() {
        overlay = menu
    }

    func activateAfterMenu() {
        overlay = afterMenu
    }

    func activateOnboarding(for controllerType: MovementManagerType?) {
        switch controllerType {
        case .motion:
            overlay = motionOnboarding
        case .touch:
            overlay = touchOnboarding
        default:
            overlay = hud
        }
    }
}
