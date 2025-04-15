import CoreData
import PhotosUI
import SwiftUI

@Observable
@MainActor
final class ReceiptFormViewModel {

    enum AlertType: String, Identifiable {
        case error

        var id: String { rawValue }
    }

    var alertType: AlertType?

    var selectedItem: PhotosPickerItem? {
        didSet {
            Task { await loadImage() }
        }
    }

    var isFormValid: Bool {
        guard
            displayModel.image.size.width > 0,
            displayModel.amount > 0,
            !displayModel.currency.isEmpty
        else { return false }
        return true
    }

    var isEditing: Bool = false
    var displayModel = ReceiptDisplayModel()
    var receipt: Receipt?

    private let context = CoreDataManager.shared.context
    private let coordinator: Coordinator
    private let repository: RepositoryProtocol

    init(
        coordinator: Coordinator,
        repository: RepositoryProtocol,
        receipt: Receipt? = nil
    ) {
        self.receipt = receipt
        self.coordinator = coordinator
        self.repository = repository

        isEditing = receipt != nil
        makeDisplayModel()
    }

    // MARK: - Helpers

    func loadImage() async {
        guard let data = try? await selectedItem?.loadTransferable(type: Data.self),
              let uiImage = UIImage(data: data)
        else { return }
        displayModel.image = uiImage
    }

    func save() {
        var tempReceipt: Receipt?
        if isEditing {
            tempReceipt = receipt
        } else {
            tempReceipt = Receipt(context: context)
            tempReceipt?.id = UUID()
        }

        tempReceipt?.date = displayModel.date
        tempReceipt?.amount = displayModel.amount
        tempReceipt?.currency = displayModel.currency
        tempReceipt?.imageData = displayModel.image.jpegData(compressionQuality: 0.8)

        do {
            try repository.saveContext()
            
            coordinator.goBack()
        } catch {
            alertType = .error
        }
    }

    private func makeDisplayModel() {
        guard let receipt else { return }
        displayModel = ReceiptDisplayModel(
            amount: receipt.amount,
            currency: receipt.currency ?? "",
            date: receipt.date ?? Date(),
            image: UIImage(data: receipt.imageData ?? Data()) ?? UIImage()
        )
    }
}

