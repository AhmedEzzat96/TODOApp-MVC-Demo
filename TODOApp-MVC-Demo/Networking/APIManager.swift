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
    class func deleteTask(with id: String, completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaultsManager.shared().token else { return }
        
        let headers: HTTPHeaders = [HeaderKeys.authorization: "Bearer \(token)",
            HeaderKeys.contentType: "application/json"]
        
        AF.request(URLs.task + "/\(id)", method: HTTPMethod.delete, parameters: nil, encoding: JSONEncoding.default, headers: headers).response {
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
        
        AF.request(URLs.UserData, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers).response {
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
    class func logOut(completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaultsManager.shared().token else { return }
        
        let headers: HTTPHeaders = [HeaderKeys.authorization: "Bearer \(token)",
            HeaderKeys.contentType: "application/json"]
        
        AF.request(URLs.logOut, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: headers).response {
            response in
            guard response.error == nil else {
                print("Errorrr" + response.error!.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // Upload photo
    class func uploadPhoto(with image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let imageJpegData = image.jpegData(compressionQuality: 0.8),
            let token = UserDefaultsManager.shared().token else {return}
        
        let headers: HTTPHeaders = [HeaderKeys.authorization: "Bearer \(token)"]
        
        AF.upload(multipartFormData: { (formData) in
            formData.append(imageJpegData, withName: "avatar", fileName: "/home/ali/Mine/c/nodejs-blog/public/img/blog-header.jpg", mimeType: "blog-header.jpg")
        }, to: URLs.uploadPhoto, method: HTTPMethod.post, headers: headers).response {
            response in
            guard response.error == nil else {
                print(response.error!.localizedDescription)
                completion(false)
                return
            }
            print(response)
            completion(true)
        }
    }
    
    // getUserPhoto
    class func getProfilePhoto(with id: String, completion: @escaping (_ error: Error?,_ image: Data?,_ imageResponse: ImageResponse?) -> Void) {
        
        AF.request("\(URLs.user)/\(id)/avatar", method: .get).response {
            response in
            guard response.error == nil else {
                print(response.error!)
                completion(response.error!, nil, nil)
                return
            }
            
            print(response)
            
            guard let data = response.data else {
                print("can't find any data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let imageData = try decoder.decode(ImageResponse.self, from: data)
                completion(nil, nil, imageData)
            } catch let error {
                print(error)
                completion(nil, data, nil)
            }
        }
    }
    
    // update user information in api
    class func updateUser(with name: String?, email: String?, age: Int?, completion: @escaping (Bool, UpdateUserResponse?) -> Void) {
        guard let token = UserDefaultsManager.shared().token else { return }
        
        let headers: HTTPHeaders = [HeaderKeys.authorization: "Bearer \(token)",
            HeaderKeys.contentType: "application/json"]
        var params: [String: Any] = [:]
        
        if let name = name, !name.isEmpty {
            params.updateValue(name, forKey: ParameterKeys.name)
        }
        if let email = email, !email.isEmpty {
            params.updateValue(email, forKey: ParameterKeys.email)
        }
        if let age = age, age > 0 {
            params.updateValue(age, forKey: ParameterKeys.age)
        }
        
        print(params)
        
        AF.request(URLs.UserData, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            guard response.error == nil else {
                print(response.error!)
                completion(false, nil)
                return
            }
            
            guard let data = response.data else {
                print("can't get any data")
                completion(false, nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let updateUserResponse = try decoder.decode(UpdateUserResponse.self, from: data)
                completion(true, updateUserResponse)
            } catch let error {
                print(error)
                completion(false, nil)
            }
        }
    }

}
