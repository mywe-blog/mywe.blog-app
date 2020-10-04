import Foundation
import Combine
import Alamofire

public protocol Client {
    func dataTask(request: URLRequest, completion: @escaping (Data?, Error?) -> Void)
}

extension URLSession: Client {
    public func dataTask(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        dataTask(with: request) { data, response, error in
            completion(data, error)
        }.resume()
    }
}

extension URLSession {
    //swiftlint:disable large_tuple
    func synchronousDataTask(urlrequest: URLRequest) -> (data: Data?, response: URLResponse?, error: Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        let dataTask = self.dataTask(with: urlrequest) {
            data = $0
            response = $1
            error = $2

            semaphore.signal()
        }
        dataTask.resume()

        _ = semaphore.wait(timeout: .distantFuture)

        return (data, response, error)
    }
}

public struct SynchronousClient: Client {
    private let urlSession: URLSession

    public init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    public func dataTask(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        let (data, _, error) = urlSession.synchronousDataTask(urlrequest: request)
        completion(data, error)
    }
}

public final class MyWeBlogService {
    private let baseURL: URL
    private let client: Client

    private let decoder = JSONDecoder()

    public enum Endpoint {
        case createEntry(_ entry: PostContent)
        case uploadImage(repo: String, accessToken: String, imageData: Data)

        var path: String {
            switch self {
            case .createEntry:
                return "post_content"
            case .uploadImage:
                return "upload_image"
            }
        }

        var multipart: Bool {
            switch self {
            case .createEntry:
                return false
            case .uploadImage:
                return true
            }
        }

        var method: String {
            switch self {
            case .createEntry, .uploadImage:
                return "POST"
            }
        }

        var httpBody: Data? {
            switch self {
            case .createEntry(let entry):
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                encoder.keyEncodingStrategy = .convertToSnakeCase
                return try? encoder.encode(entry)
            case .uploadImage(let repo, let accessToken, let imageData):
                return nil
            }
        }

        var contentType: String {
            switch self {
            case .createEntry:
                return "application/json"
            case .uploadImage(let repo, let accessToken, let imageData):
            return ""
            }
        }
    }

    public init(baseURL: URL,
                client: Client) {
        self.baseURL = baseURL
        self.client = client
 
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }

    public func perform<T: Codable>(endpoint: Endpoint) -> Future<T, Error> {
        let queryURL = baseURL.appendingPathComponent(endpoint.path)

        switch endpoint {
        case .uploadImage(let repo, let accessToken, let imageData):
            return Future<T, Error> { promise in
                let filename = UUID().uuidString + ".jpg"
                AF.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(repo.data(using: .utf8)!, withName: "repo")
                    multipartFormData.append(accessToken.data(using: .utf8)!, withName: "access_token")
                    multipartFormData.append(imageData, withName: "file", fileName: filename, mimeType: "image/jpeg")
                },
                to: queryURL,
                usingThreshold: UInt64.init(),
                method: .post)
                .responseJSON { response in
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    guard let data = response.data,
                          let content = try? decoder.decode(T.self, from: data) else {
                        return
                    }
                    promise(.success(content))
                }
            }
        default:
            var request = URLRequest(url: queryURL)
            request.httpMethod = endpoint.method
            request.httpBody = endpoint.httpBody
            request.setValue(endpoint.contentType, forHTTPHeaderField: "Content-Type")

            return Future<T, Error> { promise in
                self.client.dataTask(request: request) { data, error in
                            guard let data = data else {
                                promise(.failure(error!))
                                return
                            }

                            do {
                                let object = try self.decoder.decode(T.self, from: data)
                                DispatchQueue.main.async {
                                    promise(.success(object))
                                }
                            } catch let error {
                                DispatchQueue.main.async {
                                    #if DEBUG
                                    print("JSON Decoding Error: \(error)")
                                    #endif
                                    promise(.failure(error))
                                }
                            }
                        }
            }
        }
    }
}

struct Empty: Codable { }

