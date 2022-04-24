//
//  NetworkService.swift
//  Domicil
//
//  Created by Никита Гусев on 21.04.2022.
//

import Foundation
import RxSwift

// MARK: - NetworkError
enum NetworkError: Error {
    case invalidUrl
    case noData
    case invalidData
    case noResponse
}

// MARK: - HTTPMethod
enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case patch = "PATCH"
    case post = "POST"
    case delete = "DELETE"
}

// MARK: - ResponseProcessorType
protocol ResponseProcessorType {
    func extractError(from response: URLResponse) -> Error?
}

// MARK: - NetworkServiceType
protocol NetworkServiceType {
    func fetchModel<T: Decodable>(
        path: String,
        method: HTTPMethod,
        params: [String: Any],
        body: Data?,
        additionalHeaders: [HeaderConvertible],
        responseProcessor: ResponseProcessorType?,
        decoder: JSONDecoder
    ) -> Single<T>
    
    func fetch(
        path: String,
        method: HTTPMethod,
        params: [String: Any],
        body: Data?,
        additionalHeaders: [HeaderConvertible],
        responseProcessor: ResponseProcessorType?
    ) -> Single<Void>
    
    func fetchData(from url: URL) -> Single<Data>
}

extension NetworkServiceType {
    func fetchModel<T: Decodable>(
        path: String,
        method: HTTPMethod,
        params: [String: Any] = [:],
        body: Data? = nil,
        additionalHeaders: [HeaderConvertible] = [],
        responseProcessor: ResponseProcessorType? = nil,
        decoder: JSONDecoder = JSONDecoder()
    ) -> Single<T> {
        fetchModel(
            path: path,
            method: method,
            params: params,
            body: body,
            additionalHeaders: additionalHeaders,
            responseProcessor: responseProcessor,
            decoder: decoder
        )
    }
    
    func fetch(
        path: String,
        method: HTTPMethod,
        params: [String: Any] = [:],
        body: Data? = nil,
        additionalHeaders: [HeaderConvertible] = [],
        responseProcessor: ResponseProcessorType? = nil
    ) -> Single<Void> {
        fetch(
            path: path,
            method: method,
            params: params,
            body: body,
            additionalHeaders: additionalHeaders,
            responseProcessor: responseProcessor
        )
    }
}

// MARK: - NetworkService
class NetworkService: NetworkServiceType {
    private let baseUrl: URL
    private let commonHeaders: [HeaderConvertible]
    private let responseProcessor: ResponseProcessorType
    private let session: URLSession
    
    init(
        baseUrl: URL,
        commonHeaders: [HeaderConvertible] = [],
        responseProcessor: ResponseProcessorType,
        session: URLSession = URLSession(configuration: .default)
    ) {
        self.baseUrl = baseUrl
        self.commonHeaders = commonHeaders
        self.responseProcessor = responseProcessor
        self.session = session
    }
    
    func fetchModel<T: Decodable>(
        path: String,
        method: HTTPMethod,
        params: [String: Any],
        body: Data?,
        additionalHeaders: [HeaderConvertible],
        responseProcessor: ResponseProcessorType?,
        decoder: JSONDecoder
    ) -> Single<T> {
        dataTask(
            path: path,
            method: method,
            params: params,
            body: body,
            additionalHeaders: additionalHeaders,
            responseProcessor: responseProcessor
        )
        .flatMap { data, _ in
            guard let data = data else {
                return .error(NetworkError.noData)
            }

            guard let decodedObject = try? decoder.decode(T.self, from: data) else {
                return .error(NetworkError.invalidData)
            }
            
            return .just(decodedObject)
        }
    }
    
    func fetch(
        path: String,
        method: HTTPMethod,
        params: [String: Any],
        body: Data?,
        additionalHeaders: [HeaderConvertible],
        responseProcessor: ResponseProcessorType?
    ) -> Single<Void> {
        dataTask(
            path: path,
            method: method,
            params: params,
            body: body,
            additionalHeaders: additionalHeaders,
            responseProcessor: responseProcessor
        )
        .map { _, _ in }
    }
    
    func fetchData(from url: URL) -> Single<Data> {
        session.rx.data(request: .init(url: url))
            .asSingle()
    }
}

// MARK: - Private methods
private extension NetworkService {
    func dataTask(
        path: String,
        method: HTTPMethod,
        params: [String: Any],
        body: Data?,
        additionalHeaders: [HeaderConvertible],
        responseProcessor: ResponseProcessorType?
    ) -> Single<(Data?, URLResponse)> {
        let headers = unwrapHeaders(commonHeaders + additionalHeaders)
        
        let request = createRequest(
            path: path,
            params: params,
            method: method,
            headers: headers,
            body: body
        )
        
        guard let request = request else {
            return .error(NetworkError.invalidUrl)
        }
        
        return session.rx.dataTask(
            for: request,
            responseProcessor: responseProcessor ?? self.responseProcessor
        )
    }
    
    func createRequest(
        path: String,
        params: [String: Any],
        method: HTTPMethod,
        headers: [String: String],
        body: Data?
    ) -> URLRequest? {
        guard let url = createUrl(path: path, params: params) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        return request
    }
    
    func createUrl(
        path: String,
        params: [String: Any]
    ) -> URL? {
        guard var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        urlComponents.path = path
        let queryItems = params.map {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }
        urlComponents.queryItems = !queryItems.isEmpty ? queryItems : nil
        
        return urlComponents.url
    }
    
    func unwrapHeaders(_ headersArray: [HeaderConvertible]) -> [String: String] {
        return Dictionary(headersArray)
    }
}
