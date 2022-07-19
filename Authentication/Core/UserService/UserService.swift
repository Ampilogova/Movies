//
//  UserService.swift
//  Authentication
//
//  Created by Tatiana Ampilogova on 6/14/22.
//

import Foundation

protocol UserService {
    func requestSession(sessionId: String, completion: @escaping (Result<User, Error>) -> Void)
}

class UserServiceImpl: UserService {

    private let api = "3c9b031364b6f545dad2b09a7c77b22b"
    private let url = "https://api.themoviedb.org/3/account?"
    private let networkService: NetworkService
    private let decoder = JSONDecoder()
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func requestSession(sessionId: String, completion: @escaping (Result<User, Error>) -> Void) {
        var request = NetworkRequest(url: url)
        request.parameters["session_id"] = sessionId
        request.parameters["api_key"] = api
        
        networkService.send(request: request) { [weak self]  result in
            switch result {
            case .success(let data):
                let userInfo = try? self?.decoder.decode(User.self, from: data)
                if let userInfo = userInfo {
                    completion (.success(userInfo))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
