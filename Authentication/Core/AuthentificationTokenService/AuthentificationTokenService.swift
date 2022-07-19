//
//  AuthentificationService.swift
//  Authentication
//
//  Created by Tatiana Ampilogova on 6/14/22.
//

import Foundation

protocol AuthentificationTokenService {
    func getToken(completion: @escaping (Result<AuthentificationToken, Error>) -> Void)
}

class AuthentificationTokenServiceImpl: AuthentificationTokenService {

    private let api = "3c9b031364b6f545dad2b09a7c77b22b"
    private let url = "https://api.themoviedb.org/3/authentication/token/new"
    private let networkService: NetworkService
    private let decoder = JSONDecoder()
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getToken(completion: @escaping (Result<AuthentificationToken, Error>) -> Void) {
        var request = NetworkRequest(url: url)
        request.parameters["api_key"] = api
        
        networkService.send(request: request) { [weak self]  result in
            switch result {
            case .success(let data):
                let token = try? self?.decoder.decode(AuthentificationToken.self, from: data)
                if let token = token {
                    completion(.success(token))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
