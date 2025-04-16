import Foundation

enum ReceiptsViewState: Equatable {
    case idle
    case loading
    case present([Receipt])
    case error(String)
    case empty
}
