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
