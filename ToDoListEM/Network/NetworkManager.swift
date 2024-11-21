import Foundation
import Alamofire

final class NetworkManager{
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchTasks(completion: @escaping (Result<TaskModel, AFError>) -> Void){
        AF.request("https://dummyjson.com/todos")
            .validate()
            .responseDecodable(of: TaskModel.self) { dataResponse in
                switch dataResponse.result{
                case .success(let tasks):
                    print("Done!")
                    completion(.success(tasks))
                case .failure(let error):
                    print("Error!")
                    completion(.failure(error))
                }
            }
    }
}
