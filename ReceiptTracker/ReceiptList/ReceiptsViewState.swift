import Foundation

enum ReceiptsViewState {
    case idle
    case loading
    case present([Receipt])
    case error(String)
    case empty
}
