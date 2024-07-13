import UIKit
import CoreData
import Fakery

struct PersistenceController {
    
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        
        let faker = Faker(locale: "ru")
        for i in 0..<50 {
            let worker = Worker(context: controller.container.viewContext)
            worker.firstname = faker.name.firstName()
            worker.subname = faker.name.lastName()
            worker.wcountry = faker.address.country()
            worker.birthday = faker.business.creditCardExpiryDate()
        }
        
        return controller
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                print(error)
//                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
            }
        }
    }
}
