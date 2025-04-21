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
        let mock = MockRequestExecutor()
        let mockJSON = """
        {
            "todos": [
                {
                    "id": 1,
                    "todo": "Test 1",
                    "description": "Description 1",
                    "date": "2025-04-21",
                    "completed": false
                },
                {
                    "id": 2,
                    "todo": "Test 2",
                    "description": "Description 2",
                    "date": "2025-04-22",
                    "completed": true
                }
            ]
        }
        """.data(using: .utf8)!
        
        mock.mockData = mockJSON
        let networkManager = NetworkManager(requestExecutor: mock)
        
        let expectation = XCTestExpectation(description: "Tasks fetched successfully")
        
        networkManager.fetchTasks { result in
            switch result {
            case .success(let model):
                XCTAssertEqual(model.todos.count, 2)
                XCTAssertEqual(model.todos[0].todo, "Test 1")
                XCTAssertFalse(model.todos[0].completed)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, got failure")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchTasksFailed() throws {
        
        let mock = MockRequestExecutor()
        mock.shouldReturnError = true
        let networkManager = NetworkManager(requestExecutor: mock)
        
        let expectation = XCTestExpectation(description: "Tasks fetch failed")
        
        networkManager.fetchTasks { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertEqual(error.responseCode, 500)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

class MockRequestExecutor: NetworkRequestProtocol {
    var shouldReturnError = false
    var mockData: Data?
    
    func request<TaskModel: Decodable>(_ url: URLConvertible, completion: @escaping (Result<TaskModel, AFError>) -> Void) {
        if shouldReturnError {
            completion(.failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 500))))
        } else if let data = mockData {
            do {
                let decoded = try JSONDecoder().decode(TaskModel.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(AFError.responseSerializationFailed(reason: .decodingFailed(error: error))))
            }
        }
    }
}
