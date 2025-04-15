import SwiftUI

struct ContentView: View {

    @State private var coordinator = Coordinator()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(screen: .receiptsView)
            .navigationDestination(for: Route.self) { screen in
                coordinator.build(screen: screen)
            }
            .navigationTitle(Localized.Receipts.title)
        }
    }
}

#Preview {
    ContentView()
}
