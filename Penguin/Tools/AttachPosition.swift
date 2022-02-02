import SceneKit

enum GeometryPosition {
    enum Y {
        case top, bottom, mid
    }
    enum X {
        case left, right, mid
    }
    enum Z {
        case front, back, mid
    }
}

struct AttachPosition {
    fileprivate let x: GeometryPosition.X
    fileprivate let y: GeometryPosition.Y
    fileprivate let z: GeometryPosition.Z
    
    init(_ x: GeometryPosition.X, _ y: GeometryPosition.Y, _ z: GeometryPosition.Z) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    func getPosition(in node: SCNNode) -> SCNVector3 {
        let boundingBox = node.boundingBox
        var position = SCNVector3()

        switch x {
        case .left:
            position.x = boundingBox.min.x
        case .right:
            position.x = boundingBox.max.x
        case .mid:
            position.x = 0
        }
        switch y {
        case .top:
            position.y = boundingBox.max.y
        case .bottom:
            position.y = boundingBox.min.y
        case .mid:
            position.y = 0
        }
        switch z {
        case .back:
            position.z = boundingBox.max.z
        case .front:
            position.z = boundingBox.min.z
        case .mid:
            position.z = 0
        }

        return position
    }

}

extension SCNNode {
    func addChildNode(_ child: SCNNode, at attachment: AttachPosition) {
        self.addChildNode(child)
        child.position = attachment.getPosition(in: self)
    }
}
