import Foundation

extension ClosedRange where Bound == Double {
    var size: Bound {
        return self.upperBound - self.lowerBound
    }
}
