import SwiftUI
import PhotosUI

struct ReceiptsView: View {
    
    @State var viewModel = ReceiptsViewModel()

    var body: some View {
        NavigationView {
            switch viewModel.viewState {
            case .idle:
                Color.clear
                    .onAppear {
                        viewModel.fetchReceipts()
                    }
            case .loading:
                progressView
            case let .present(receipts):
                contentView(receipts)
            case let .error(error):
                errorView(error)
            case .empty:
                emptyView()
            }
        }
    }

    // MARK: Loading

    @ViewBuilder var progressView: some View {
        ProgressView()
            .controlSize(.large)
            .padding()
            .accessibilityLabel(A11y.Receipts.loading)
            .accessibilityIdentifier("Progress view")
    }

    // MARK: Content

    @ViewBuilder func contentView(_ receipts: [Receipt]) -> some View {
        List {
            ForEach(receipts) { receipt in
                HStack {
                    if let uiImage = viewModel.getImage(from: receipt.imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: Receipts.Image.size, height: Receipts.Image.size)
                            .cornerRadius(Receipts.Image.cornerRadius)
                            .accessibilityLabel(A11y.Receipts.receiptImage)
                            .accessibilityIdentifier("Receipt image")
                    }

                    VStack(alignment: .leading) {
                        Text("\(receipt.amount, specifier: "%.2f") \(receipt.currency ?? "")")
                            .accessibilityLabel(A11y.Receipts.receiptAmount("\(receipt.amount)"))
                            .accessibilityIdentifier("Receipt amount")

                        if let date = receipt.date {
                            Text(date, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .accessibilityLabel(A11y.Receipts.receiptDate(viewModel.convertDateToString(date)))
                                .accessibilityIdentifier("Receipt date")
                        }
                    }
                }
            }
            .onDelete(perform: viewModel.removeReceipt)
        }
        .navigationTitle(Localized.Receipts.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(Localized.Receipts.add, systemImage: "plus") {
                    viewModel.addReceipt()
                }
                .accessibilityLabel(A11y.Receipts.addButton)
                .accessibilityIdentifier("Add button")
            }
        }
        .accessibilityLabel(A11y.Receipts.receiptList)
        .accessibilityIdentifier("Receipt list")
    }

    // MARK: Error

    @ViewBuilder func errorView(_ error: String) -> some View {
        VStack(spacing: Space.medium) {
            Text(error.capitalizingFirstLetter())
                .font(.title3)

            Button {
                viewModel.fetchReceipts()
            } label: {
                Text(Localized.Receipts.refresh)
            }
            .buttonStyle(.borderedProminent)
            .font(.body)
            .accessibilityLabel(A11y.Receipts.refreshButton)
            .accessibilityIdentifier("Refresh button")
        }
    }

    // MARK: Empty

    @ViewBuilder func emptyView() -> some View {
        VStack(spacing: Space.medium) {
            Text(Localized.Receipts.emptyMessage)
                .font(.title3)

            Button {
                viewModel.addReceipt()
            } label: {
                Text(Localized.Receipts.addReceipt)
            }
            .buttonStyle(.borderedProminent)
            .font(.body)
            .accessibilityLabel(A11y.Receipts.addReceiptButton)
            .accessibilityIdentifier("Add receipt button")
        }
    }
}
