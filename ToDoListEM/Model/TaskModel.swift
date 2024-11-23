import Foundation

struct TaskModel: Decodable{
    var todos: [ToDoS]
}

struct ToDoS: Decodable{
    var id: Int
    var todo: String
    var description: String?
    var date: String?
    var completed: Bool
    
    init(todo: String, description: String?, date: String?, completed: Bool, id: Int) {
        self.id = id
        self.todo = todo
        self.description = description
        self.date = "01/01/24"
        self.completed = completed
    }
}
