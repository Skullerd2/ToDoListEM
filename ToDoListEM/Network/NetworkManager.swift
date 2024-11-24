import Foundation
import Alamofire

protocol NetworkRequestProtocol {
    func request<T: Decodable>(_ url: URLConvertible, completion: @escaping (Result<T, AFError>) -> Void)
}
extension Session: NetworkRequestProtocol {
    func request<T: Decodable>(_ url: URLConvertible, completion: @escaping (Result<T, AFError>) -> Void) {
        self.request(url)
            .validate()
            .responseDecodable(of: T.self) { response in
                completion(response.result)
            }
    }
}


final class NetworkManager {
    static let shared = NetworkManager()

    private let requestExecutor: NetworkRequestProtocol

    init(requestExecutor: NetworkRequestProtocol = Session.default) {
        self.requestExecutor = requestExecutor
    }
    private init() {
        self.requestExecutor = Session.default
    }


    func fetchTasks(completion: @escaping (Result<TaskModel, AFError>) -> Void) {
        requestExecutor.request("https://dummyjson.com/todos", completion: completion)
    }
}
