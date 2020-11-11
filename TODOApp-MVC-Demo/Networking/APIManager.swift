import Foundation
import Alamofire

class APIManager {
    
    // login user to api
    class func  login(with user: User, completion: @escaping (Result<AuthResponse, Error>) -> Void){
        request(APIRouter.login(user)){ (response) in
            completion(response)
        }
    }
    
    // register user to api
    class func register(with user: User, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        request(APIRouter.register(user)) { (response) in
            completion(response)
        }
    }
    
    // add task to api
    class func addTask(with task: Task, completion: @escaping (Bool) -> Void) {
        requestBool(APIRouter.addTask(task)) { (response) in
            completion(response)
        }
    }
    
    // get all tasks for a user from api
    class func getAllTasks(completion: @escaping (Result<GetTasksResponse, Error>) -> Void) {
        request(APIRouter.getTasks) { (response) in
            completion(response)
        }
    }
    
    // delete task by id from api
    class func deleteTask(with id: String, completion: @escaping (Bool) -> ()) {
        requestBool(APIRouter.deleteTask(id)) { (response) in
            completion(response)
        }
    }
    
    // get user data from api by token
    class func getUserData(completion: @escaping (Result<UserData, Error>) -> Void) {
        request(APIRouter.getUserData) { (response) in
            completion(response)
        }
    }
    
    // logout user from api by token
    class func logOut(completion: @escaping (Bool) -> Void) {
        requestBool(APIRouter.logOut) { (response) in
            completion(response)
        }
    }
    
    // Upload photo
    class func uploadPhoto(with image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let imageJpegData = image.jpegData(compressionQuality: 0.8) else { return }
        upload(APIRouter.uploadPhoto, data: imageJpegData) { (response) in
            completion(response)
        }
    }
    
    // getUserPhoto
    class func getProfilePhoto(with id: String, completion: @escaping (Result<Data, Error>) -> Void) {
        requestData(APIRouter.getProfilePhoto(id)) { (response) in
            completion(response)
        }
    }
    
    // update user information in api
    class func updateUser(with user: User?, completion: @escaping (Bool) -> Void) {
        requestBool(APIRouter.updateUser(user)) { (response) in
            completion(response)
        }
    }
}

extension APIManager{
    // MARK:- The request function to get results in a closure
    private static func request<T: Decodable>(_ urlConvertible: URLRequestConvertible, completion:  @escaping (Result<T, Error>) -> ()) {
        // Trigger the HttpRequest using AlamoFire
        AF.request(urlConvertible).responseDecodable { (response: AFDataResponse<T>) in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        .responseJSON { response in
            print(response)
        }
    }
    
    // MARK:- The request function to get result Data
    private static func requestData(_ urlConvertible: URLRequestConvertible, completion:  @escaping (Result<Data, Error>) -> ()) {
        // Trigger the HttpRequest using AlamoFire
        AF.request(urlConvertible).response { (response) in
            switch response.result {
            case .success(let data):
                guard let data = data else {return}
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        .responseJSON { response in
            switch response.result {
                
            case .success(_):
                print(response)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK:- The request function to get results in Bool
    private static func requestBool(_ urlConvertible: URLRequestConvertible, completion:  @escaping (Bool) -> ()) {
        // Trigger the HttpRequest using AlamoFire
        AF.request(urlConvertible).response { (response) in
            switch response.result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    // MARK:- The upload function to get results in Bool
    private static func upload(_ urlConvertible: URLRequestConvertible, data: Data, completion:  @escaping (Bool) -> ()) {
        // Trigger the HttpRequest using AlamoFire
        AF.upload(multipartFormData: { (formData) in
            formData.append(data, withName: "avatar", fileName: "/home/ali/Mine/c/nodejs-blog/public/img/blog-header.jpg", mimeType: "blog-header.jpg")
        }, with: urlConvertible).response {
            response in
            switch response.result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
}
