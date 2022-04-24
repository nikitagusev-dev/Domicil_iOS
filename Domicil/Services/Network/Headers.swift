//
//  Headers.swift
//  HealthyLife
//
//  Created by Никита Гусев on 21.04.2022.
//

import Foundation

// MARK: - HeaderConvertible
protocol HeaderConvertible {
    var header: (String, String) { get }
}

extension Dictionary where Key == String, Value == String {
    init(_ headerConvertibles: [HeaderConvertible]) {
        self.init(headerConvertibles.map(\.header)) { $1 }
    }
}

// MARK: - Header
enum Header {
    enum Authorization {
        case basic(user: String, password: String)
        case bearer(token: String)
    }
    
    enum ContentType {
        case json
        case formData(String)
    }
    
    case custom(key: String, value: String)
}

// MARK: - CustomHeader to HeaderConvertible
extension Header: HeaderConvertible {
    var header: (String, String) {
        switch self {
            case let .custom(key, value):
                return (key, value)
        }
    }
}

// MARK: - Authorization to HeaderConvertible
extension Header.Authorization: HeaderConvertible {
    var header: (String, String) {
        switch self {
            case let .basic(user, password):
                let credentialsData = "\(user):\(password)".data(using: .utf8)!
                return ("Authorization", "Basic ".appending(credentialsData.base64EncodedString()))
            case let .bearer(token):
                return ("Authorization", "Bearer ".appending(token))
        }
    }
}

// MARK: - ContentType to HeaderConvertible
extension Header.ContentType: HeaderConvertible {
    var header: (String, String) {
        switch self {
            case .json:
                return ("Content-Type", "application/json")
            case .formData(let boundary):
                return ("Content-Type", "multipart/form-data; boundary=\(boundary)")
        }
    }
}
