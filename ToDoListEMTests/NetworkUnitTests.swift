import XCTest
import Alamofire
@testable import ToDoListEM
final class NetworkUnitTests: XCTestCase {

    var networkManager: NetworkManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        networkManager = NetworkManager.shared
    }

    override func tearDownWithError() throws {
        networkManager = nil
        try super.tearDownWithError()
    }

    func testFetchTasksSuccess() throws {
        let expectation = expectation(description: "Успешное получение задач")

        networkManager.fetchTasks { result in
            switch result {
            case .success(let taskModel):
                XCTAssertNotNil(taskModel.todos)
                XCTAssertFalse(taskModel.todos.isEmpty)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Ошибка: \(error)")
            }
        }

        waitForExpectations(timeout: 5)
    }
    
    func testToDoSInit() {
        let todo = ToDoS(todo: "Тестовая задача", description: "Тестовое описание", date: "24.11.2024", completed: true, id: 1)
        XCTAssertEqual(todo.todo, "Тестовая задача")
        XCTAssertEqual(todo.description, "Тестовое описание")
        XCTAssertEqual(todo.date, "01/01/24")
        XCTAssertEqual(todo.completed, true)
        XCTAssertEqual(todo.id, 1)
    }
}
