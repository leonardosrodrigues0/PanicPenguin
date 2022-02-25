import SpriteKit

protocol OverlayableSKScene: SKScene {
    func updateOverlay()
    func containsInteractableObject(_ touches: Set<UITouch>) -> Bool
    func processTouch(_ touches: Set<UITouch>)
}

extension OverlayableSKScene {
    func updateOverlay() {}

    func containsInteractableObject(_ touches: Set<UITouch>) -> Bool {
        false
    }

    func processTouch(_ touches: Set<UITouch>) {}

    static var fontName: String {
        "AvenirNext-HeavyItalic"
    }
}

protocol OverlayableSKSceneDelegate: AnyObject {
    func willInteractWithOverlay()
    func didInteractWithOverlay(withSuccess: Bool)
    func interactWithOverlay(_ touches: Set<UITouch>)
    var isInteractingWithOverlay: Bool { get set }
    var overlay: OverlayableSKScene? { get set }
}

extension OverlayableSKSceneDelegate {
    func interactWithOverlay(_ touches: Set<UITouch>) {
        willInteractWithOverlay()
        let success = overlay?.containsInteractableObject(touches) ?? false
        overlay?.processTouch(touches)
        didInteractWithOverlay(withSuccess: success)
    }

    func willInteractWithOverlay() {
        isInteractingWithOverlay = true
    }

    func didInteractWithOverlay(withSuccess: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.isInteractingWithOverlay = false
        }
    }

}
