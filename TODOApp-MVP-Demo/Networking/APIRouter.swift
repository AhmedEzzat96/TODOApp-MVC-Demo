
import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible{
    
    // The endpoint name
    case login(_ user: User)
    case register(_ user: User)
    case getTasks, getUserData, logOut, uploadPhoto
    case addTask(_ task: Task)
    case deleteTask(_ id: String)
    case getProfilePhoto(_ id: String)
    case updateUser(_ user: User?)
    // MARK: - HttpMethod
    private var method: HTTPMethod {
        switch self{
        case .getTasks, .getUserData, .getProfilePhoto:
            return .get
        case .deleteTask:
            return .delete
        case .updateUser:
            return .put
        default:
            return .post
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        default:
            return nil
        }
    }
    // MARK: - Path
    private var path: String {
        switch self {
        case .login:
            return URLs.login
        case .getTasks, .addTask:
            return URLs.task
        case .register:
            return URLs.signup
        case .deleteTask(let id):
            return URLs.task + "/\(id)"
        case .getUserData, .updateUser:
            return URLs.UserData
        case .logOut:
            return URLs.logOut
        case .uploadPhoto:
            return URLs.uploadPhoto
        case .getProfilePhoto(let id):
            return URLs.user + "/\(id)" + "/avatar"
        }
    }
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try URLs.base.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        //httpMethod
        urlRequest.httpMethod = method.rawValue
        switch self {
        case .getTasks, .addTask, .deleteTask, .getUserData, .logOut, .uploadPhoto, .updateUser:
            urlRequest.setValue("Bearer \(UserDefaultsManager.shared().token ?? "")",
            forHTTPHeaderField: HeaderKeys.authorization)
            
        default:
            break
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: HeaderKeys.contentType)
        
        // HTTP Body
        let httpBody: Data? = {
            switch self {
            case .register(let body):
                return encodeToJSON(body)
            case .login(let body):
                return encodeToJSON(body)
            case .updateUser(let body):
                return encodeToJSON(body)
            case .addTask(let body):
                return encodeToJSON(body)
            default:
                return nil
            }
        }()
        urlRequest.httpBody = httpBody
        
        // Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get, .delete:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        print(try encoding.encode(urlRequest, with: parameters))
        return try encoding.encode(urlRequest, with: parameters)
    }
    
}

extension APIRouter {
    private func encodeToJSON<T: Encodable>(_ body: T) -> Data? {
        do {
            let anyEncodable = AnyEncodable(body)
            let jsonData = try JSONEncoder().encode(anyEncodable)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            return jsonData
        } catch {
            print(error)
            return nil
        }
    }
}

// type-erasing wrapper
struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    
    public init<T: Encodable>(_ wrapped: T) {
        _encode = wrapped.encode
    }
    
    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}
