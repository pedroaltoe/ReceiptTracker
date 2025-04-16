import SwiftUI

// MARK: Route

enum Route: Hashable {
    case receiptsView
    case openReceiptView(Receipt?)
}

@Observable
class Coordinator {

    var path = NavigationPath()

    // MARK: Navigation

    func navigate(to route: Route) {
        path.append(route)
    }

    func goBack() {
        path = NavigationPath()
    }

    // MARK: Screen builder

    @MainActor
    @ViewBuilder
    func build(screen: Route) -> some View {
        let repository = RepositoryBuilder.makeRepository()
        switch screen {
        case .receiptsView:
            ReceiptsView(
                viewModel: ReceiptsViewModel(
                    coordinator: self,
                    repository: repository
                )
            )
        case let .openReceiptView(receipt):
            ReceiptFormView(
                viewModel: ReceiptFormViewModel(
                    coordinator: self,
                    repository: repository,
                    receipt: receipt
                )
            )
        }
    }
}

#if targetEnvironment(simulator)
final class MockCoordinator: Coordinator {

    var didNavigateBack = false

    var lastRoute: Route?

    override func navigate(to route: Route) {
        lastRoute = route
    }

    override func goBack() {
        didNavigateBack = true
    }
}
#endif
