import XCTest
import CoreData
@testable import ToDoListEM

class ViewControllerTests: XCTestCase {
    
    var viewController: ViewController!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewController = ViewController()
        
        let persistentContainer = NSPersistentContainer(name: "TaskDataModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error loading persistent stores: \(error)")
            }
        }
        context = persistentContainer.viewContext
        
        viewController.context = context
    }
    
    override func tearDownWithError() throws {
        viewController = nil
        context = nil
        try super.tearDownWithError()
    }
    
    func testSaveTask() throws {
        
    }
    
    func testDeleteTask() throws {
        
    }
}
