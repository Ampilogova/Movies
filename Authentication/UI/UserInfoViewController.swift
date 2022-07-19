//
//  UserInfoViewController.swift
//  Authentication
//
//  Created by Tatiana Ampilogova on 6/14/22.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    private let userService = UserServiceImpl(networkService: NetworkServiceImpl())
    private let sessionId: String
    
    init(sessionId: String) {
        self.sessionId = sessionId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var userName: UILabel = {
        var label = UILabel()
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        loadUserInfo()
    }
    
    func loadUserInfo() {
        userService.requestSession(sessionId: sessionId) { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.userName.text = user.username
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupUI() {
        userName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userName)
        NSLayoutConstraint.activate([
            userName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userName.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

}
