import XCTest
import CoreData
@testable import ToDoListEM

class CoreDataTests: XCTestCase {
    
    var mockContext: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let persistentContainer = NSPersistentContainer(name: "TaskDataModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        
        persistentContainer.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        
        mockContext = persistentContainer.viewContext
    }
    
    override func tearDownWithError() throws {
        mockContext = nil
        try super.tearDownWithError()
    }
    
    func testSaveTask() throws {
        
        let todo = "Покормить кошку"
        let descript = "В 4 часа дня"
        let completed = false
        let date = "21/04/2025"
        
        let task = try CoreDataManager.shared.saveTask(
            todo: todo,
            descript: descript,
            completed: completed,
            date: date,
            context: mockContext
        )
        
        XCTAssertEqual(task.todo, todo)
        XCTAssertEqual(task.descrip, descript)
        XCTAssertEqual(task.completed, completed)
        XCTAssertEqual(task.date, date)
    }
    
    
    func testDeleteTask() throws {
        let todo = "Покормить кошку"
        let descript = "В 4 часа дня"
        let completed = false
        let date = "21/04/2025"
        
        let task = try CoreDataManager.shared.saveTask(
            todo: todo,
            descript: descript,
            completed: completed,
            date: date,
            context: mockContext
        )
        
        try CoreDataManager.shared.deleteTask(task, context: mockContext)
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let result = try mockContext.fetch(fetchRequest)
        XCTAssertTrue(result.isEmpty)
    }
    
    func testUpdateTask() throws {
        let todo = "Покормить кошку"
        let descript = "В 4 часа дня"
        let completed = false
        let date = "21/04/2025"
        
        let newTodo = "Покормить собаку"
        let newCompleted = true
        
        
        let task = try CoreDataManager.shared.saveTask(
            todo: todo,
            descript: descript,
            completed: completed,
            date: date,
            context: mockContext
        )
        
        try CoreDataManager.shared.updateTask(
            task,
            todo: newTodo,
            descript: descript,
            completed: newCompleted,
            date: date,
            context: mockContext
        )
        
        XCTAssertEqual(task.todo, newTodo)
        XCTAssertNotEqual(task.completed, completed)
        
    }
}
