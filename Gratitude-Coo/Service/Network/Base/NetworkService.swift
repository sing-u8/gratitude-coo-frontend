// NetworkService.swift
import Foundation
import Combine

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, NetworkError>
}

class NetworkService: NetworkServiceProtocol {
    private let baseURL: URL
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        guard let url = URL(string: NetworkConfig.baseURL) else {
            fatalError("Invalid base URL: \(NetworkConfig.baseURL)")
        }
        self.baseURL = url
        self.session = session
    }
    
    // 테스트를 위해 커스텀 baseURL을 허용하는 보조 이니셜라이저
    init(baseURL: String, session: URLSession = .shared) {
        guard let url = URL(string: baseURL) else {
            fatalError("Invalid base URL: \(baseURL)")
        }
        self.baseURL = url
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, NetworkError> {
        guard let request = createRequest(for: endpoint) else {
            return Fail(error: NetworkError.invalidRequest).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .mapError { NetworkError.requestFailed($0) }
            .flatMap { data, response -> AnyPublisher<Data, NetworkError> in
                guard let httpResponse = response as? HTTPURLResponse else {
                    return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    return Fail(error: NetworkError.httpError(statusCode: httpResponse.statusCode, data: data)).eraseToAnyPublisher()
                }
                
                return Just(data)
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    return NetworkError.decodingFailed(decodingError)
                } else if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func createRequest(for endpoint: APIEndpoint) -> URLRequest? {
        guard let url = URL(string: endpoint.path, relativeTo: baseURL) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // 기본 헤더와 엔드포인트별 헤더 병합
        var headers = NetworkConfig.defaultHeaders
        if let endpointHeaders = endpoint.headers {
            // 엔드포인트 헤더가 기본 헤더를 덮어쓰도록 함
            headers.merge(endpointHeaders) { (_, new) in new }
        }
        request.allHTTPHeaderFields = headers
        
        if let body = endpoint.body {
            do {
                // JSON 직렬화를 시도하고 실패 시 nil 반환
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("Error serializing request body: \(error)")
                return nil
            }
        }
        
        return request
    }
}
