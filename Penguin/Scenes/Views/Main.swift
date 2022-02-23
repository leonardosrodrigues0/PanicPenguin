import SwiftUI

class PenguinHostingController: UIHostingController<Main> {
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: Main())
    }
}

struct MenuView: View {
    var body: some View {
        Button(action: {
            GameManager.shared.playerMovement?.controllerType = .touch
            GameManager.shared.startGame()
        }, label: {
            Text("Play")
                .padding()
                .background(Color.red)
        })
    }
}

struct Main: View {
    @ObservedObject private var viewModel = ViewModel()

    var body: some View {
        ZStack {
            GameView()
            switch viewModel.state {
            case .menu:
                MenuView()
            default:
                Text("NOT MENU")
            }
        }
    }

    class ViewModel: ObservableObject, GameManagerDelegate {
        @Published var state: GameState

        init() {
            state = GameManager.shared.state
        }

        func didResetGame() {
            <#code#>
        }

        func didStartGame() {
            state = GameManager.shared.state
        }

        func didEnterDeathState() {
            <#code#>
        }
    }
}

struct GameView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "Game", bundle: Bundle.main)
        let controller = storyboard.instantiateInitialViewController()!
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}
