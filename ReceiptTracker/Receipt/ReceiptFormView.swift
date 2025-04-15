import SwiftUI
import PhotosUI

struct ReceiptFormView: View {

    @Bindable var viewModel: ReceiptFormViewModel

    var body: some View {
        Form {
            imagePicker
            datePicker
            amount
            currency
        }
        .navigationTitle(Localized.ReceiptForm.title(viewModel.isEditing))
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(Localized.ReceiptForm.saveButton) {
                    viewModel.save()
                }
                .disabled(!viewModel.isFormValid)
            }
        }
        .alert(item: $viewModel.alertType) {
            switch $0 {
            case .error:
                return makeErrorAlert()
            }
        }
    }

    // MARK: - Image Picker

    @ViewBuilder var imagePicker: some View {
        Section(header: Text(Localized.ReceiptForm.photoSectionTitle)) {
            Image(uiImage: viewModel.displayModel.image)
                .resizable()
                .scaledToFit()
                .cornerRadius(ReceiptForm.Image.cornerRadius)

            PhotosPicker(
                Localized.ReceiptForm.photosPickerButtonTitle,
                selection: $viewModel.selectedItem,
                matching: .images
            )
        }
        .accessibilityLabel(A11y.ReceiptForm.imagePicker)
        .accessibilityIdentifier("Image picker")
    }

    // MARK: - Date Picker

    @ViewBuilder var datePicker: some View {
        Section(header: Text(Localized.ReceiptForm.dateSectionTitle)) {
            DatePicker(
                Localized.ReceiptForm.datePickerTitle,
                selection: $viewModel.displayModel.date,
                displayedComponents: .date
            )
        }
        .accessibilityLabel(A11y.ReceiptForm.datePicker)
        .accessibilityIdentifier("Date picker")
    }

    // MARK: - Amount

    @ViewBuilder var amount: some View {
        Section(header: Text(Localized.ReceiptForm.amountSectionTitle)) {
            TextField(
                Localized.ReceiptForm.amountPlaceholder,
                value: $viewModel.displayModel.amount,
                format: .number
            )
            .keyboardType(.decimalPad)
        }
        .accessibilityLabel(A11y.ReceiptForm.amountField)
        .accessibilityIdentifier("Amount field")
    }

    // MARK: - Currency

    @ViewBuilder var currency: some View {
        Section(header: Text(Localized.ReceiptForm.currencySectionTitle)) {
            TextField(
                Localized.ReceiptForm.currencyPlaceHolder,
                text: $viewModel.displayModel.currency
            )
            .autocapitalization(.allCharacters)
        }
        .accessibilityLabel(A11y.ReceiptForm.currencyField)
        .accessibilityIdentifier("Currency field")
    }

    // MARK: - Error

    private func makeErrorAlert() -> Alert {
        Alert(title: Text(Localized.ReceiptForm.saveItemErrorMessage))
    }
}
