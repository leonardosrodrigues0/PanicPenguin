import Foundation
import SceneKit

protocol MovementManager {
    /// Returns the move with distance (absolute value) and direction (signal)
    func getMove() -> Double?

    /// For managers that need to be set. Empty default implementation is provided.
    func startUpdates()
    /// For managers that need to be unset. Empty default implementation is provided.
    func stopUpdates()

    /// Touches handling method. Empty default implementation is provided for managers that do not use touches.
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, view: UIView)
    /// Touches handling method. Empty default implementation is provided for managers that do not use touches.
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, view: UIView)
    /// Touches handling method. Empty default implementation is provided for managers that do not use touches.
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, view: UIView)
}

extension MovementManager {
    func startUpdates() {}
    func stopUpdates() {}

    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, view: UIView) {}
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, view: UIView) {}
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, view: UIView) {}
}

enum MovementManagerType {
    case motion
    case touch

    var newManager: MovementManager {
        switch self {
        case .motion:
            return MotionMovementManager()
        case .touch:
            return TouchMovementManager()
        }
    }
}
