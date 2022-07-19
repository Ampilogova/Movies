//
//  ValidateUserService.swift
//  Authentication
//
//  Created by Tatiana Ampilogova on 6/14/22.
//

import Foundation

protocol ValidateUserService {
    
    func validateUser(username: String, password: String, token: String, completion: @escaping (Result<UserAuthentication, Error>) -> Void)
}

class ValidateUserServiceImpl: ValidateUserService {
    
    private let api = "3c9b031364b6f545dad2b09a7c77b22b"
    private let urlString = "https://api.themoviedb.org/3/authentication/token/validate_with_login"
    private let networkService: NetworkService
    private let decoder = JSONDecoder()

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func validateUser(username: String, password: String, token: String, completion: @escaping (Result<UserAuthentication, Error>) -> Void) {
        
        var request = NetworkRequest(url: urlString)
        request.httpMethod = "POST"
        request.parameters = ["api_key": api]
        request.postParameters = ["username": username, "password": password, "request_token": token]
        request.httpHeaders["Content-Type"] = "application/json"
        
        networkService.send(request: request) { result in
            switch result {
            case .success(let data):
                if let userAuthentication = try? self.decoder.decode(UserAuthentication.self, from: data) {
                    completion(.success(userAuthentication))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

