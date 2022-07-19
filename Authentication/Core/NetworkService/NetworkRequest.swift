//
//  NetworkRequest.swift
//  Authentication
//
//  Created by Tatiana Ampilogova on 6/14/22.
//

import Foundation

struct NetworkRequest {
    var url: String
    var parameters = [String: String]()
    var httpMethod = "GET"
    var postParameters: [String: String]?
    var httpHeaders = [String: String]()
    
    var data: Data? {
        guard let postParameters = postParameters else {
            return nil
        }
        return try? JSONSerialization.data(withJSONObject: postParameters, options: [])
    }
    
    init(url: String) {
        self.url = url
    }
    
    func buildURL() -> URL? {
        var urlComponents = URLComponents(string: url)
        urlComponents?.queryItems = parameters.map({ URLQueryItem(name: $0, value: $1) })
        
        return urlComponents?.url
    }
}
