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
            Text("PLAY")
                .padding()
                .background(Color.red)
        })
    }
}

struct HudView: View {
    var body: some View {
        Button(action: {
            GameManager.shared.togglePause()
        }, label: {
            Text("PAUSE")
                .padding()
                .background(Color.red)
        })
    }
}

struct AfterMenuView: View {
    var body: some View {
        Button(action: {
            GameManager.shared.reset()
        }, label: {
            Text("RESET")
                .padding()
                .background(Color.red)
        })
    }
}

struct Main: View {
    @ObservedObject private var viewModel = ViewModel()

    var body: some View {
        ZStack {
            GameView(state: $viewModel.state)
            switch viewModel.state {
            case .menu:
                MenuView()
            case .dead:
                AfterMenuView()
            default:
                HudView()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    class ViewModel: ObservableObject, GameManagerDelegate {
        @Published var state: GameState

        init() {
            state = GameManager.shared.state
            GameManager.shared.delegate = self
        }

        func didUpdateState() {
            state = GameManager.shared.state
        }
    }
}

struct GameView: UIViewControllerRepresentable {
    @Binding var state: GameState

    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "Game", bundle: Bundle.main)
        let controller = storyboard.instantiateInitialViewController()!
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard let controller = uiViewController as? GameViewController else {
            return
        }

        print("UPDATE \(state)")
        if state == .menu {
            controller.updateScene()
        }
    }
}
