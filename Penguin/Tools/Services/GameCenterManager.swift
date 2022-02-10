import UIKit
import GameKit

enum LeaderboardType: String {
    case test
}

class GameCenterManager: NSObject {
    
    static let shared = GameCenterManager()
    
    var viewController: UIViewController?
    
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
            if GKLocalPlayer.local.isAuthenticated {
                print("Usuário autenticado")
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
        let vc = GKGameCenterViewController(leaderboardID: id.rawValue, playerScope: .global, timeScope: .allTime)
        vc.gameCenterDelegate = self
        viewController?.present(vc, animated: true, completion: nil)
    }
    
    func score(_ value: Int) {
        if value > highestScore {
            print("Novo record")
            highestScore = value
            postScore(value, to: .test)
        }
    }
    
    private func postScore(_ score: Int, to leaderboardID: LeaderboardType) {
        GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [leaderboardID.rawValue]) { error in
            print(error?.localizedDescription ?? "Score has been posted to \(leaderboardID.rawValue)")
        }
    }
}

extension GameCenterManager: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
