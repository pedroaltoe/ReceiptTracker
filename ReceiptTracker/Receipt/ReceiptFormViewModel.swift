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
        let doubleAmount = convertStringAmountToDouble()
        guard
            displayModel.image.size.width > 0,
            doubleAmount > 0,
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
        tempReceipt?.amount = convertStringAmountToDouble()
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
            amount: String(receipt.amount),
            currency: receipt.currency ?? "",
            date: receipt.date ?? Date(),
            image: UIImage(data: receipt.imageData ?? Data()) ?? UIImage()
        )
    }

    func formatAmountString(_ input: String, locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = locale
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2

        guard
            let number = Double(input),
            let formatted = formatter.string(from: NSNumber(value: number))
        else { return input }

        return formatted
    }

    func validateAmount(_ newValue: String) {
        let filtered = newValue.filter { "0123456789.,".contains($0) }
        let dots = filtered.filter { $0 == "." }
        let commas = filtered.filter { $0 == "," }

        if
            dots.count <= 1,
            commas.count <= 1
        {
            displayModel.amount = filtered
        } else {
            displayModel.amount = String(filtered.dropLast())
        }
    }

    func convertStringAmountToDouble() -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current

        let normalizedString = displayModel.amount.replacingOccurrences(of: ",", with: ".")

        guard let number = formatter.number(from: displayModel.amount) else {
            return Double(normalizedString) ?? 0
        }

        return number.doubleValue
    }
}

