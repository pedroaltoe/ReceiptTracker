import Foundation
import SwiftUI
import CoreData

@Observable
@MainActor
final class ReceiptsViewModel {

    var viewState: ReceiptsViewState
    var receipts: [Receipt] = []

    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

    private let context = CoreDataManager.shared.context

    init() {
        viewState = .idle
        fetchReceipts()
    }

    // MARK: Fetch data

    func fetchReceipts() {
        viewState = .loading
        let request: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Receipt.date, ascending: false)]

        do {
            receipts = try context.fetch(request)
            viewState = receipts.isEmpty ? .empty : .present(receipts)
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }

    // MARK: Actions

    func addReceipt() {
        print("Add receipt")
    }

    func openReceipt() {
        print("Open receipt")
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
            CoreDataManager.shared.delete(receipt)
        }

        fetchReceipts()
    }
}
