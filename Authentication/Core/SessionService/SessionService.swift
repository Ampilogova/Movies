//
//  CreateSession.swift
//  Authentication
//
//  Created by Tatiana Ampilogova on 6/14/22.
//

import Foundation

protocol SessionService {
    func requestSession(token: String, completion: @escaping (Result<Session, Error>) -> Void)
}

class SessionServiceImpl: SessionService {

    private let api = "3c9b031364b6f545dad2b09a7c77b22b"
    private let url = "https://api.themoviedb.org/3/authentication/session/new?"
    private let networkService: NetworkService
    private let decoder = JSONDecoder()
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func requestSession(token: String, completion: @escaping (Result<Session, Error>) -> Void) {
        var request = NetworkRequest(url: url)
        request.parameters["request_token"] = token
        request.parameters["api_key"] = api
        
        networkService.send(request: request) { [weak self]  result in
            switch result {
            case .success(let data):
                let id = try? self?.decoder.decode(Session.self, from: data)
                if let id = id {
                    completion (.success(id))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
