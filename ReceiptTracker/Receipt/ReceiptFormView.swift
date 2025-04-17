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
        .sheet(isPresented: $viewModel.isShowingCamera) {
            CameraView { uiImage in
                viewModel.handleImage(uiImage)
            }
        }
    }

    // MARK: - Image Picker

    @ViewBuilder var imagePicker: some View {
        Section(header: Text(Localized.ReceiptForm.photoSectionTitle)) {
            if viewModel.displayModel.image.size.width > 0 {
                Image(uiImage: viewModel.displayModel.image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(ReceiptForm.Image.cornerRadius)
            }

            Button(Localized.ReceiptForm.takePhotoButtonTitle) {
                viewModel.isShowingCamera = true
            }
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
                text: $viewModel.displayModel.amount
            )
            .keyboardType(.decimalPad)
            .onChange(of: viewModel.displayModel.amount) { _, newValue in
                viewModel.validateAmount(newValue)
            }
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
