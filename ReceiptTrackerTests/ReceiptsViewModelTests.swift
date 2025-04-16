import XCTest
@testable import ReceiptTracker

@MainActor
final class ReceiptsViewModelTests: XCTestCase {

    func test_fetchReceipts_success_setsPresentState() {
        let receipt = makeReceipt()
        let mockRepository = MockRepository()
        mockRepository.fetchedReceipts = [receipt]

        let viewModel = makeViewModel(repository: mockRepository)

        XCTAssertEqual(viewModel.receipts.count, 1)

        switch viewModel.viewState {
        case .present(let receipts):
            XCTAssertEqual(receipts.count, 1)
        default:
            XCTFail("Expected .present viewState")
        }
    }

    func test_fetchReceipts_empty_setsEmptyState() {
        let mockRepository = MockRepository()
        mockRepository.fetchedReceipts = []

        let viewModel = makeViewModel(repository: mockRepository)

        XCTAssertEqual(viewModel.receipts.count, 0)
        XCTAssertEqual(viewModel.viewState, .empty)
    }

    func test_fetchReceipts_error_setsErrorState() {
        let mockRepository = MockRepository()
        mockRepository.shouldThrow = true

        let viewModel = makeViewModel(repository: mockRepository)

        switch viewModel.viewState {
        case let .error(error):
            XCTAssertEqual(error, MockRepository.MockError.fetch.localizedDescription)
        default:
            XCTFail("Expected .error state")
        }
    }

    func test_removeReceipt_deletesReceipt() {
        let receipt = makeReceipt()
        let mockRepository = MockRepository()
        mockRepository.fetchedReceipts = [receipt]

        let viewModel = makeViewModel(repository: mockRepository)

        viewModel.removeReceipt(at: IndexSet(integer: 0))

        XCTAssertEqual(mockRepository.deletedReceipt, receipt)
    }

    func test_removeReceipt_error_setsAlert() {
        let receipt = makeReceipt()
        let mockRepository = MockRepository()
        mockRepository.fetchedReceipts = [receipt]
        mockRepository.shouldThrow = true

        let viewModel = makeViewModel(repository: mockRepository)
        viewModel.receipts = [receipt]
        viewModel.removeReceipt(at: IndexSet(integer: 0))

        XCTAssertEqual(viewModel.alertType, .error)
    }

    func test_addReceipt_navigatesToAdd() {
        let mockRepository = MockRepository()
        let mockCoordinator = MockCoordinator()

        let viewModel = makeViewModel(
            coordinator: mockCoordinator,
            repository: mockRepository
        )

        viewModel.addReceipt()

        guard case .openReceiptView(let receipt)? = mockCoordinator.lastRoute else {
            return XCTFail("Expected navigation to .openReceiptView")
        }

        XCTAssertNil(receipt)
    }

    func test_openReceipt_navigatesToEdit() {
        let mockRepository = MockRepository()
        let mockCoordinator = MockCoordinator()
        let receipt = makeReceipt()

        let viewModel = makeViewModel(
            coordinator: mockCoordinator,
            repository: mockRepository
        )

        viewModel.openReceipt(receipt)

        guard case .openReceiptView(let openedReceipt)? = mockCoordinator.lastRoute else {
            return XCTFail("Expected navigation to .openReceiptView")
        }

        XCTAssertEqual(openedReceipt, receipt)
    }

    // MARK: Helper

    private func makeReceipt() -> Receipt {
        let context = CoreDataManager.shared.context
        let receipt = Receipt(context: context)
        receipt.amount = 99.99
        receipt.date = Date()
        return receipt
    }

    private func makeViewModel(
        coordinator: Coordinator = Coordinator(),
        repository: MockRepository
    ) -> ReceiptsViewModel {
        ReceiptsViewModel(
            coordinator: coordinator,
            repository: repository
        )
    }
}

