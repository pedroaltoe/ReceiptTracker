enum A11y {
    enum Receipts {
        static let addButton = "Add button"
        static let addReceiptButton = "Add receipt button"
        static let loading = "Loading"
        static let receiptImage = "Receipt image"
        static let receiptList = "Receipt list"
        static let refreshButton = "Refresh screen button"

        static func receiptAmount(_ amount: String) -> String {
            "Receipt amount \(amount)"
        }

        static func receiptDate(_ date: String) -> String {
            "Receipt date from \(date)"
        }
    }

    enum ReceiptForm {
        static let amountField = "Amount field"
        static let currencyField = "Currency field"
        static let datePicker = "Date picker"
        static let imagePicker = "Image picker"
    }
}
