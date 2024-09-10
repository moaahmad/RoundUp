//
//  URLRequest+Extensions.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Foundation

extension URLRequest {
    public enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
}

extension URLRequest {
    public init(
        method: HTTPMethod,
        url: URL,
        bodyData: Data? = nil
    ) {
        self.init(url: url)
        httpMethod = method.rawValue
        addValue("application/json", forHTTPHeaderField: "Accept")
        addValue(APIConstants.bearerToken, forHTTPHeaderField: "Authorization")
        
        if [HTTPMethod.post, .put].contains(method) {
            httpBody = bodyData
            addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
}
