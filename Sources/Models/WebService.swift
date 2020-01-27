import Foundation

/*
 
 (example)
 
 class MyWebService: WebService {
 
    static let shared: MyService = MyService(baseURL: URL(string: "http://127.0.0.1:8080")!)
 
    func getResource(completion: @escaping (Result<Resource, Swift.Error>) -> Void) -> URLSessionDataTask {
        return get(path: "resource", completion: completion)
    }
 
 }
 
 */

class WebService {
    
    enum Error: Swift.Error {
        case httpError(statusCode: Int)
        case invalidData
    }
        
    let baseURL: URL
    let session: URLSession
    
    var token: String? = nil
    
    // MARK: - Initialization
    
    init(baseURL: URL, userAgent: String? = nil) {
        self.baseURL = baseURL
        
        let configuration = URLSessionConfiguration.default
        if let ua = userAgent {
            configuration.httpAdditionalHeaders = ["Content-Type": "application/json",
                                                   "Accept": "application/json",
                                                   "User-Agent": ua]
        } else {
            configuration.httpAdditionalHeaders = ["Content-Type": "application/json",
                                                   "Accept": "application/json"]
        }
        
        let mb = 1024 * 1024
        configuration.urlCache = URLCache(memoryCapacity: 5 * mb, diskCapacity: 25 * mb, diskPath: nil)
        
        session = URLSession(configuration: configuration)
    }
    
    // MARK: - Functions
    
    @discardableResult
    func request(path: String, method: String? = nil, body: Data? = nil, completion: @escaping (Result<Data, Swift.Error>) -> Void) -> URLSessionDataTask {
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        
        let task = session.dataTask(with: request) { data, response, error in
            if let e = error {
                completion(.failure(e))
                return
            }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            
            guard (200...299).contains(statusCode) else {
                completion(.failure(Error.httpError(statusCode: statusCode)))
                return
            }
            
            guard let d = data else {
                completion(.failure(Error.invalidData))
                return
            }
            
            completion(.success(d))
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func requestJSON<T: Decodable>(path: String, method: String? = nil, completion: @escaping (Result<T, Swift.Error>) -> Void) -> URLSessionDataTask {
        return request(path: path, method: method) { result in
            switch result {
            case .success(let data):
                if let o = try? JSONDecoder().decode(T.self, from: data), self.validateResult(path: path, result: .success(o)) {
                    completion(.success(o))
                } else {
                    self.validateResult(path: path, result: .failure(Error.invalidData))
                    completion(.failure(Error.invalidData))
                }
            case .failure(let error):
                self.validateResult(path: path, result: .failure(error))
                completion(.failure(error))
            }
        }
    }
    
    @discardableResult
    func requestJSON<S: Encodable, T: Decodable>(path: String, method: String, body: S? = nil, completion: @escaping (Result<T, Swift.Error>) -> Void) -> URLSessionDataTask {
        return request(path: path, method: method, body: try? JSONEncoder().encode(body.self)) { result in
            switch result {
            case .success(let data):
                if let o = try? JSONDecoder().decode(T.self, from: data), self.validateResult(path: path, result: .success(o)) {
                    completion(.success(o))
                } else {
                    self.validateResult(path: path, result: .failure(Error.invalidData))
                    completion(.failure(Error.invalidData))
                }
            case .failure(let error):
                self.validateResult(path: path, result: .failure(error))
                completion(.failure(error))
            }
        }
    }
    
    @discardableResult
    func head<T: Decodable>(path: String, completion: @escaping (Result<T, Swift.Error>) -> Void) -> URLSessionDataTask {
        return requestJSON(path: path, method: "HEAD", completion: completion)
    }
    
    @discardableResult
    func get<T: Decodable>(path: String, completion: @escaping (Result<T, Swift.Error>) -> Void) -> URLSessionDataTask {
        return requestJSON(path: path, method: "GET", completion: completion)
    }
    
    @discardableResult
    func post<S: Encodable, T: Decodable>(path: String, body: S? = nil,completion: @escaping (Result<T, Swift.Error>) -> Void) -> URLSessionDataTask {
        return requestJSON(path: path, method: "POST", body: body, completion: completion)
    }
    
    @discardableResult
    func put<S: Encodable, T: Decodable>(path: String, body: S? = nil,completion: @escaping (Result<T, Swift.Error>) -> Void) -> URLSessionDataTask {
        return requestJSON(path: path, method: "PUT", body: body, completion: completion)
    }
    
    @discardableResult
    func patch<S: Encodable, T: Decodable>(path: String, body: S? = nil,completion: @escaping (Result<T, Swift.Error>) -> Void) -> URLSessionDataTask {
        return requestJSON(path: path, method: "PATCH", body: body, completion: completion)
    }
    
    @discardableResult
    func delete<T: Decodable>(path: String, completion: @escaping (Result<T, Swift.Error>) -> Void) -> URLSessionDataTask {
        return requestJSON(path: path, method: "DELETE", completion: completion)
    }
    
    // MARK: - Subclassing
    
    @discardableResult
    func validateResult(path: String, result: Result<Decodable, Swift.Error>) -> Bool { return true }
    
}
