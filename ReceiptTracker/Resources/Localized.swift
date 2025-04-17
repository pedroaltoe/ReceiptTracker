import Foundation

enum Localized {
    enum Receipts {
        static let add = String(localized: "Add")
        static let addReceipt = String(localized: "Add receipt")
        static let deleteItemErrorMessage = String(localized: "Item couldn't be deleted, please try again later.")
        static let emptyMessage = String(localized: "There are no receipts added yet.")
        static let refresh = String(localized: "Refresh")
        static let title = String(localized: "Receipts")
    }

    enum ReceiptForm {
        static let amountPlaceholder = String(localized: "Amount")
        static let amountSectionTitle = String(localized: "Total Amount")
        static let currencyPlaceHolder = String(localized: "Currency (e.g., USD)")
        static let currencySectionTitle = String(localized: "Currency")
        static let datePickerTitle = String(localized: "Date")
        static let dateSectionTitle = String(localized: "Date")
        static let photoSectionTitle = String(localized: "Receipt Photo")
        static let saveButton = String(localized: "Save")
        static let saveItemErrorMessage = String(localized: "Item couldn't be saved, please try again later.")
        static let takePhotoButtonTitle = String(localized: "Take Photo")

        static func title(_ isEditing: Bool) -> String {
            isEditing ? "Edit Receipt" : "New Receipt"
        }
    }
}
