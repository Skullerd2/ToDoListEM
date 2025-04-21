import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    func saveTask(todo: String, descript: String, completed: Bool, date: String, context: NSManagedObjectContext) throws -> Task{
        let task = Task(context: context)
        task.todo = todo
        task.descrip = descript
        task.completed = completed
        task.date = date
        
        try context.save()
        return task
    }
    
    func updateTask(_ task: Task, todo: String, descript: String, completed: Bool, date: String, context: NSManagedObjectContext) throws {
        task.todo = todo
        task.descrip = descript
        task.completed = completed
        task.date = date
        try context.save()
    }
    
    func deleteTask(_ task: Task, context: NSManagedObjectContext) throws {
        context.delete(task)
        try context.save()
    }
}
