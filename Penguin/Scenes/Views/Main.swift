import SwiftUI

struct Main: View {
    var body: some View {
        Text("Hello, World!")
    }
}

class PenguinHostingController: UIHostingController<Main> {
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: Main())
    }
}
