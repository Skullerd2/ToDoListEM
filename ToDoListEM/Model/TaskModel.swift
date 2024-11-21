import Foundation

struct TaskModel: Decodable{
    var todos: [ToDoS]
}

struct ToDoS: Decodable{
    var todo: String
    var description: String?
    var date: String?
    var completed: Bool
    
    init(todo: String, description: String? = nil, date: String? = nil, completed: Bool) {
        self.todo = todo
        self.description = todo
        self.date = "01/01/24"
        self.completed = completed
    }
}
