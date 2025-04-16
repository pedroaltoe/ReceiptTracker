import XCTest
@testable import ReceiptTracker

@MainActor
final class ReceiptFormViewModelTests: XCTestCase {

    var mockCoordinator: MockCoordinator!
    var mockRepository: MockRepository!
    var viewModel: ReceiptFormViewModel!

    override func setUp() {
        super.setUp()
        mockCoordinator = MockCoordinator()
        mockRepository = MockRepository()
        viewModel = makeViewModel(
            coordinator: mockCoordinator,
            repository: mockRepository
        )
    }

    override func tearDown() {
        mockCoordinator = nil
        mockRepository = nil
        viewModel = nil
        super.tearDown()
    }

    func test_isFormValid_whenAllFieldsAreValid_shouldBeTrue() {
        viewModel.displayModel.amount = "12.50"
        viewModel.displayModel.currency = "USD"
        viewModel.displayModel.image = UIImage(systemName: "doc")!

        XCTAssertTrue(viewModel.isFormValid)
    }

    func test_isFormValid_whenFieldsAreInvalid_shouldBeFalse() {
        viewModel.displayModel.amount = "0"
        viewModel.displayModel.currency = ""
        viewModel.displayModel.image = UIImage()

        XCTAssertFalse(viewModel.isFormValid)
    }

    func test_save_whenNewReceipt_shouldSaveAndNavigateBack() {
        viewModel.displayModel.amount = "99.99"
        viewModel.displayModel.currency = "USD"
        viewModel.displayModel.date = Date()
        viewModel.displayModel.image = UIImage(systemName: "doc")!

        viewModel.save()

        XCTAssertTrue(mockRepository.saveCalled)
        XCTAssertTrue(mockCoordinator.didNavigateBack)
        XCTAssertNil(viewModel.alertType)
    }

    func test_save_whenRepositoryThrows_shouldSetAlertTypeError() {
        mockRepository.shouldThrow = true
        viewModel.displayModel.amount = "123"
        viewModel.displayModel.currency = "USD"
        viewModel.displayModel.image = UIImage(systemName: "doc")!

        viewModel.save()

        XCTAssertEqual(viewModel.alertType, .error)
    }

    func test_convertStringAmountToDouble_validInput_returnsDouble() {
        viewModel.displayModel.amount = "123.45"
        let result = viewModel.convertStringAmountToDouble()
        XCTAssertEqual(result, 123.45, accuracy: 0.01)
    }

    func test_formatAmountString_enUS() {
        let formatted = viewModel.formatAmountString("1234.56", locale: Locale(identifier: "en_US"))
        XCTAssertEqual(formatted, "1,234.56")
    }

    func test_formatAmountString_portugal() {
        let formatted = viewModel.formatAmountString("1234.56", locale: Locale(identifier: "pt_PT"))
        XCTAssertEqual(formatted, "1234,56")
    }

    func test_formatAmountString_invalidInput() {
        let formatted = viewModel.formatAmountString("abc", locale: Locale(identifier: "pt_PT"))
        XCTAssertEqual(formatted, "abc")
    }

    // MARK: Helper

    private func makeViewModel(
        coordinator: MockCoordinator,
        repository: MockRepository
    ) -> ReceiptFormViewModel {
        ReceiptFormViewModel(
            coordinator: coordinator,
            repository: repository
        )
    }
}

