//
//  URLSession+Rx.swift
//  Domicil
//
//  Created by Никита Гусев on 21.04.2022.
//

import Foundation
import RxSwift

extension Reactive where Base == URLSession {
    func dataTask(
        for request: URLRequest
    ) -> Single<(Data?, URLResponse)> {
        Single.create { single in
            log(request)
            
            base.dataTask(with: request) { data, response, error in
                log(response, data)
                
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let response = response else {
                    single(.failure(NetworkError.noResponse))
                    return
                }
                
                single(.success((data, response)))
            }.resume()
            
            return Disposables.create()
        }
    }
    
    func dataTask(
        for request: URLRequest,
        responseProcessor: ResponseProcessorType
    ) -> Single<(Data?, URLResponse)> {
        dataTask(for: request)
            .flatMap { data, response in
                if let error = responseProcessor.extractError(from: response) {
                    return .error(error)
                }
                
                return .just((data, response))
            }
    }
    
    func data(from url: URL) -> Single<Data> {
        let request = URLRequest(url: url)
        
        return dataTask(for: request)
            .flatMap { data, _ in
                guard let data = data else {
                    return .error(NetworkError.noData)
                }
                
                return .just(data)
            }
    }
}

private func log(_ request: URLRequest) {
    let bodyString: String = {
        if let body = request.httpBody {
            return String(data: body, encoding: .utf8) ?? ""
        }
        return ""
    }()
    
    let info = """
    
    ------------------------------------
    Sent request with URL: \(String(describing: request.url)),
    Http method: \(String(describing: request.httpMethod)),
    Http headers: \(String(describing: request.allHTTPHeaderFields)),
    Body: \(bodyString)
    ------------------------------------
    
    """
    print(info)
}

private func log(_ response: URLResponse?, _ data: Data?) {
    let dataString: String = {
        if let data = data {
            return String(data: data, encoding: .utf8) ?? ""
        }
        return ""
    }()
    
    let info = """
    
    ------------------------------------
    Received response for URL: \(String(describing: response?.url)),
    Status code: \(String(describing: (response as? HTTPURLResponse)?.statusCode)),
    Data: \(dataString)
    ------------------------------------
    
    """
    print(info)
}
