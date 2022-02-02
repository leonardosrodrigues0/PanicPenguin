import SceneKit
import GameplayKit

/// Possible touch states.
enum TouchState {
    /// No touch currently on screen.
    case zero
    /// One touch on screen associated with its movement direction.
    case one(Direction)
    /// More than one touch on screen.
    case more
}

enum Direction: Int {
    case left = -1
    case right = 1
}

class TouchMovementManager: MovementManager {

    private var state = TouchState.zero

    func getMove() -> Double? {
        switch state {
        case .one(let direction):
            return Double(direction.rawValue) * Config.touchMoveDistance
        default:
            return nil
        }
    }

    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, view: UIView) {
        switch state {
        case .zero:
            exitFromZeroState(touches: touches, view: view)
        case .one:
            state = .more
        case .more:
            return
        }
    }

    private func exitFromZeroState(touches: Set<UITouch>, view: UIView) {
        if touches.count == 1 {
            let direction = Self.direction(for: touches.first!, in: view)
            state = .one(direction)
        } else {
            state = .more
        }
    }

    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, view: UIView) {
        switch state {
        case .zero:
            return
        case .one:
            state = .zero
        case .more:
            exitFromMoreState(touches: touches, event: event, view: view)
        }
    }

    private func exitFromMoreState(touches: Set<UITouch>, event: UIEvent?, view: UIView) {
        guard let eventTouches = event?.allTouches else {
            print("No event while exiting from more state")
            return
        }

        let remainingTouches = eventTouches.subtracting(touches)
        if remainingTouches.count == 1 {
            let direction = Self.direction(for: remainingTouches.first!, in: view)
            state = .one(direction)
        } else if remainingTouches.isEmpty {
            state = .zero
        } else {
            state = .more
        }
    }

    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, view: UIView) {
        switch state {
        case .one:
            changeOneStateTouchLocation(touches: touches, view: view)
        default:
            return
        }
    }

    private func changeOneStateTouchLocation(touches: Set<UITouch>, view: UIView) {
        guard touches.count == 1 else {
            print("Invalid state. Touches count different from 1 in 'one' state")
            return
        }

        let touch = touches.first!
        let direction = Self.direction(for: touch, in: view)
        state = .one(direction)
    }

    private static func direction(for touch: UITouch, in view: UIView) -> Direction {
        let touchPosition = touch.location(in: view)
        return touchPosition.x > view.frame.width / 2 ? .right : .left
    }
}
