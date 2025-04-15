import CoreData
import Foundation

final class CoreDataManager {
    
    static let shared = CoreDataManager()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: CoreData.containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }

    func fetchData() throws -> [Receipt] {
        let request: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Receipt.date, ascending: false)]

        return try context.fetch(request)
    }

    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }

    func delete(_ object: NSManagedObject) throws {
        context.delete(object)
        try saveContext()
    }
}
