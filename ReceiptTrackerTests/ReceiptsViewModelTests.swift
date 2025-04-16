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

