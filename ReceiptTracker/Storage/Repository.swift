import CoreData
import Foundation

protocol RepositoryProtocol {
    var saveContext: () throws -> Void { get }
    var delete: (NSManagedObject) throws -> Void { get }
    var fetchData: () throws -> [Receipt] { get }
}

struct Repository: RepositoryProtocol {
    var saveContext: () throws -> Void
    var delete: (NSManagedObject) throws -> Void
    var fetchData: () throws -> [Receipt]

    init(
        saveContext: @escaping () throws -> Void,
        delete: @escaping (NSManagedObject) throws -> Void,
        fetchData: @escaping () throws -> [Receipt]
    ) {
        self.saveContext = saveContext
        self.delete = delete
        self.fetchData = fetchData
    }
}

#if targetEnvironment(simulator)
final class MockRepository: RepositoryProtocol {
    enum MockError: Error {
        case save
        case delete
        case fetch
    }

    var shouldThrow = false
    var fetchedReceipts: [Receipt] = []
    var deletedReceipt: NSManagedObject?
    var saveCalled = false

    var saveContext: () throws -> Void {
        {
            if self.shouldThrow {
                throw MockError.save
            }
            self.saveCalled = true
        }
    }

    var delete: (NSManagedObject) throws -> Void {
        { object in
            if self.shouldThrow {
                throw MockError.delete
            }
            self.deletedReceipt = object
        }
    }

    var fetchData: () throws -> [Receipt] {
        {
            if self.shouldThrow {
                throw MockError.fetch
            }
            return self.fetchedReceipts
        }
    }
}
#endif
