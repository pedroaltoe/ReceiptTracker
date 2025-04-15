import SwiftUI

struct ReceiptDisplayModel {
    var amount: Double
    var currency: String
    var date: Date
    var image: UIImage

    init(
        amount: Double = 0,
        currency: String = "",
        date: Date = Date(),
        image: UIImage = UIImage()
    ) {
        self.amount = amount
        self.currency = currency
        self.date = date
        self.image = image
    }
}
