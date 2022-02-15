import UIKit
import GameKit

enum LeaderboardType: String {
    case test
}

class GameCenterManager: NSObject {
    
    static let shared = GameCenterManager()
    
    /// A ViewController responsible for presenting Game Center views
    var viewController: UIViewController?
    
    /// Checks if the local player is authenticated in Game Center. If not, then he couldn't post score to leaderboard
    var isAuthenticated: Bool {
        GKLocalPlayer.local.isAuthenticated
    }
    
    /// Stores the player highest score in the user defaults
    private(set) var highestScore: Int {
        get {
            UserDefaults.standard.integer(forKey: "highestScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "highestScore")
        }
    }
    
    private override init() {
        super.init()
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            if self.isAuthenticated {
                print("Usuário autenticado")
                self.updateLocalBest(from: .test)
            } else if let vc = vc {
                self.viewController?.present(vc, animated: true, completion: nil)
            } else if let error = error {
                print(error.localizedDescription)
            } else {
                print("Erro ao autenticar usuário ao GameCenter")
            }
        }
    }
    
    func displayLeaderboard(_ id: LeaderboardType) {
        DispatchQueue.main.async {
            let vc = GKGameCenterViewController(leaderboardID: id.rawValue, playerScope: .global, timeScope: .allTime)
            vc.gameCenterDelegate = self
            self.viewController?.present(vc, animated: true, completion: nil)
        }
    }
    
    /// Checks if the score received is better than the player's record. If so, it publishes the new record to Game Center
    func score(_ value: Int) {
        guard isAuthenticated else {
            return
        }
        
        if value > highestScore {
            highestScore = value
            postScore(value, to: .test)
        }
    }
    
    /// Publish the score to Game Center
    private func postScore(_ score: Int, to leaderboardID: LeaderboardType) {
        GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [leaderboardID.rawValue]) { error in
            print(error?.localizedDescription ?? "Score has been posted to \(leaderboardID.rawValue): \(score)")
        }
    }
    
    /// Update the player highest score into storage
    private func updateLocalBest(from leaderboardID: LeaderboardType) {
        GKLeaderboard.loadLeaderboards(IDs: [leaderboardID.rawValue]) { leaderboards, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            leaderboards?.first?.loadEntries(for: [], timeScope: .allTime) { localEntry, _, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let entry = localEntry {
                    print(entry.score)
                    self.highestScore = entry.score
                }
            }
        }
    }
}

extension GameCenterManager: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
