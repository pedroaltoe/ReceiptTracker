import Foundation

enum Space {
    static let small: CGFloat = 4
    static let medium: CGFloat = 8
    static let large: CGFloat = 12
    static let extraLarge: CGFloat = 16
    static let extraExtraLarge: CGFloat = 20
}

enum Size {
    static let extraSmall: CGFloat = 2
    static let small: CGFloat = 4
    static let medium: CGFloat = 8
    static let large: CGFloat = 12
}

enum CoreData {
    static let containerName: String = "ReceiptDataModel"
}

enum Receipts {
    enum Image {
        static let size: CGFloat = 60
        static let cornerRadius: CGFloat = 8
    }
}
