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
        let initialTaskCount = viewController.tasks.count
        let date = viewController.fetchCurrentDate()
        viewController.saveTask(todo: "Test Task", descript: "Test Description", completed: false, date: date)
        let expectation = self.expectation(description: "Save task")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(viewController.tasks.count, initialTaskCount + 1)
        let lastTask = viewController.tasks.last!
        XCTAssertEqual(lastTask.todo, "Test Task")
        XCTAssertEqual(lastTask.descrip, "Test Description")
        XCTAssertEqual(lastTask.completed, false)
        XCTAssertEqual(lastTask.date, date)
    }
    
    func testDeleteTask() throws {
        let date = viewController.fetchCurrentDate()
        viewController.saveTask(todo: "Task to Delete", descript: "Test Description", completed: false, date: date)
        let initialTaskCount = viewController.tasks.count
        let indexToDelete = initialTaskCount - 1
        
        let expectationSave = self.expectation(description: "Save task")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectationSave.fulfill()
        }
        waitForExpectations(timeout: 1)
        
        
        viewController.deleteTask(at: indexToDelete)
        
        XCTAssertEqual(viewController.tasks.count, initialTaskCount - 1)
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let fetchedTasks = try context.fetch(fetchRequest)
        XCTAssertEqual(fetchedTasks.count, initialTaskCount - 1)
        
    }
}
