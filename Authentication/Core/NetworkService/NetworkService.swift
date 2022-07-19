//
//  NetworkService.swift
//  Authentication
//
//  Created by Tatiana Ampilogova on 6/14/22.
//

import Foundation

protocol NetworkService {
    func send(request: NetworkRequest, completion: @escaping (Result<Data,Error>) -> Void)
}

class NetworkServiceImpl: NetworkService {
    
    private var urlSession = URLSession.shared
    
    func send(request: NetworkRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = request.buildURL() else {
            return
        }
        print("🐙 Sending request: \(url) with params: \(request.parameters) post params: \(request.postParameters)")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod
        urlRequest.httpBody = request.data
        for (key, value) in request.httpHeaders {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
            let str = String(decoding: data ?? Data(), as: UTF8.self)
            print("⭐️ Response for url: \(url)")
            print("Response body: \(str)")
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "NetworkError", code: -1)))
            }
        }
        dataTask.resume()
    }
}
