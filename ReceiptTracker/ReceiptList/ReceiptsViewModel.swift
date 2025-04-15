import Foundation
import SwiftUI
import CoreData

@Observable
@MainActor
final class ReceiptsViewModel {

    enum AlertType: String, Identifiable {
        case error

        var id: String { rawValue }
    }

    var alertType: AlertType?
    var viewState: ReceiptsViewState
    var receipts: [Receipt] = []

    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

    private let repository: RepositoryProtocol
    private let coordinator: Coordinator

    init(
        coordinator: Coordinator,
        repository: RepositoryProtocol
    ) {
        viewState = .idle
        self.coordinator = coordinator
        self.repository = repository

        fetchReceipts()
    }

    // MARK: Fetch data

    func fetchReceipts() {
        viewState = .loading

        do {
            receipts = try repository.fetchData()
            viewState = receipts.isEmpty ? .empty : .present(receipts)
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }

    // MARK: Actions

    func addReceipt() {
        coordinator.navigate(to: .openReceiptView(nil))
    }

    func openReceipt(_ receipt: Receipt) {
        coordinator.navigate(to: .openReceiptView(receipt))
    }

    // MARK: Helpers

    func getImage(from data: Data?) -> UIImage? {
        guard
            let data,
            let uiImage = UIImage(data: data)
        else { return nil }

        return uiImage
    }

    func convertDateToString(_ date: Date) -> String {
        Self.dateFormatter.string(from: date)
    }

    func removeReceipt(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let receipt = receipts[index]
            do {
                try repository.delete(receipt)
            } catch {
                alertType = .error
            }
        }

        fetchReceipts()
    }
}
