import Foundation

struct RepositoryBuilder {
    static func makeRepository()
    -> RepositoryProtocol {
        let context = CoreDataManager.shared

        let repository = Repository {
            try context.saveContext()
        } delete: { object in
            try context.delete(object)
        } fetchData: {
            try context.fetchData()
        }

        return repository
    }
}
