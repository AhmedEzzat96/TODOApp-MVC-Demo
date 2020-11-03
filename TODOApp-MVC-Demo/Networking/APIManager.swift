import Foundation
import Alamofire

class APIManager {
    
    // login user to api
    class func login(with email: String, password: String, completion: @escaping (_ error: Error?, _ loginData: AuthResponse?) -> Void) {
        
        let headers: HTTPHeaders = [HeaderKeys.contentType: "application/json"]
        let params: [String: Any] = [ParameterKeys.email: email,
                                     ParameterKeys.password: password]
        
        AF.request(URLs.login, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            guard response.error == nil else {
                print(response.error!)
                completion(response.error, nil)
                return
            }
            
            guard let data = response.data else {
                print("didn't get any data from API")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let loginData = try decoder.decode(AuthResponse.self, from: data)
                completion(nil, loginData)
            } catch let error {
                print(error)
                completion(error, nil)
            }
        }
    }
    
    // register user to api
    class func signup(with user: User, completion: @escaping (_ error: Error?, _ signupData: AuthResponse?) -> Void) {
        guard let name = user.name,
            let password = user.password,
            let email = user.email,
            let age = user.age else { return }
        
        let headers: HTTPHeaders = [HeaderKeys.contentType: "application/json"]
        
        let params: [String: Any] = [ParameterKeys.name: name,
                                     ParameterKeys.email: email,
                                     ParameterKeys.password: password,
                                     ParameterKeys.age: age]
        
        AF.request(URLs.signup, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            guard response.error == nil else {
                print("Errorrr" + response.error!.localizedDescription)
                completion(response.error, nil)
                return
            }
            
            guard let data = response.data else {
                print("didn't get any data from API")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let signupData = try decoder.decode(AuthResponse.self, from: data)
                completion(nil, signupData)
            } catch let error {
                print(error)
                completion(error, nil)
            }
        }
    }
    
    // add task to api
    class func addTask(with description: String, completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaultsManager.shared().token else { return }
        
        let headers: HTTPHeaders = [HeaderKeys.authorization: "Bearer \(token)",
            HeaderKeys.contentType: "application/json"]
        
        let params: [String: Any] = [ParameterKeys.description: description]
        
        AF.request(URLs.task, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            guard response.error == nil else {
                print("Errorrr" + response.error!.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // get all tasks for a user from api
    class func getAllTasks(completion: @escaping (_ error: Error?, _ taskResponse: GetTasksResponse?, _ taskData: [TaskData]?) -> Void) {
        guard let token = UserDefaultsManager.shared().token else { return }
        
        let headers: HTTPHeaders = [HeaderKeys.authorization: "Bearer \(token)",
            HeaderKeys.contentType: "application/json"]
        
        AF.request(URLs.task, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers).response {
            response in
            guard response.error == nil else {
                print("Errorrr" + response.error!.localizedDescription)
                completion(response.error, nil, nil)
                return
            }
            
            guard let data = response.data else {
                print("didn't get any data from API")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let taskResponse = try decoder.decode(GetTasksResponse.self, from: data)
                let taskData = try decoder.decode(GetTasksResponse.self, from: data).data
                completion(nil, taskResponse, taskData)
            } catch let error {
                print(error)
            }
        }
    }
    
    // delete task by id from api
    class func deleteTask(with id: String, completion: @escaping (_ success: Bool) -> Void) {
        guard let token = UserDefaultsManager.shared().token else { return }
        
        let headers: HTTPHeaders = [HeaderKeys.authorization: "Bearer \(token)",
            HeaderKeys.contentType: "application/json"]
        
        AF.request(URLs.task + "/\(id)", method: HTTPMethod.delete, parameters: nil, encoding: URLEncoding.default, headers: headers).response {
            response in
            guard response.error == nil else {
                print("Errorrr" + response.error!.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // get user data from api by token
    class func getUserData(completion: @escaping (_ error: Error?, _ userData: UserData?) -> Void) {
        guard let token = UserDefaultsManager.shared().token else { return }
        
        let headers: HTTPHeaders = [HeaderKeys.authorization: "Bearer \(token)",
            HeaderKeys.contentType: "application/json"]
        
        AF.request(URLs.getUserData, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers).response {
            response in
            guard response.error == nil else {
                print("Errorrr" + response.error!.localizedDescription)
                completion(response.error, nil)
                return
            }
            
            guard let data = response.data else {
                print("didn't get any data from API")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let userData = try decoder.decode(UserData.self, from: data)
                completion(nil, userData)
            } catch let error {
                print(error)
            }
        }
    }
    
    // logout user from api by token
    class func logOut(completion: @escaping (_ success: Bool) -> Void) {
        guard let token = UserDefaultsManager.shared().token else { return }
        
        let headers: HTTPHeaders = [HeaderKeys.authorization: "Bearer \(token)",
            HeaderKeys.contentType: "application/json"]
        
        AF.request(URLs.logOut, method: HTTPMethod.post, parameters: nil, encoding: URLEncoding.default, headers: headers).response {
            response in
            guard response.error == nil else {
                print("Errorrr" + response.error!.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }
    
}
