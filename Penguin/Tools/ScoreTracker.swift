import Foundation

class ScoreTracker {
    private(set) var score: Int = 0
    private var scoreTimer: Timer?

    func startScoreUpdates() {
        scoreTimer = Timer.scheduledTimer(withTimeInterval: Config.interval, repeats: true, block: { _ in
            self.updateScore()
        })
    }

    func pauseScoreUpdates() {
        scoreTimer?.invalidate()
        scoreTimer = nil
    }

    private func updateScore() {
        score += 1
    }
}
