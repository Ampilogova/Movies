//
//  AuthentificationViewController.swift
//  Authentication
//
//  Created by Tatiana Ampilogova on 6/14/22.
//

import UIKit

class AuthentificationViewController: UIViewController {
    
    private let validateUserService: ValidateUserService
    private let authentificationService: AuthentificationTokenService
    private let sessionService: SessionService
    
    private var token =  ""
    private var sessionId = ""
    
    init(authentificationService: AuthentificationTokenService, validateUserService: ValidateUserService, sessionService: SessionServiceImpl) {
        self.authentificationService = authentificationService
        self.validateUserService = validateUserService
        self.sessionService = sessionService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var loginTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "login"
        textField.text = "tampilogova"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    private var passwordTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "password"
        textField.text = "qYbsox-betha3-qavjin"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    private var loginButton: UIButton = {
        var button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        loginButton.addTarget(self, action: #selector(loginUser), for: .touchUpInside)
        setupUI()
        requestToken()
    }
    
    private func setupUI() {
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginTextField)
        NSLayoutConstraint.activate([
            loginTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            loginTextField.widthAnchor.constraint(equalToConstant: 300),
            loginTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 10),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: 300),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 300),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func requestToken() {
        authentificationService.getToken { [weak self] result in
            switch result {
            case .success(let token):
                DispatchQueue.main.async {
                    self?.token = token.request_token
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func validateUser() {
        validateUserService.validateUser(username: loginTextField.text ?? "", password: passwordTextField.text ?? "", token: token) { [weak self] result in
            switch result {
            case .success(let result):
                if result.success == true {
                    self?.requestSession()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func approveToken() {
        if let url = URL(string: "https://www.themoviedb.org/authenticate/\(String(describing: token))") {
            UIApplication.shared.open(url)
        }
    }

    func requestSession() {
        sessionService.requestSession(token: token) { [weak self] result in
            switch result {
            case .success(let sessionId):
                DispatchQueue.main.async {
                    UserDefaults.standard.set("1", forKey: "isLogin")
                    self?.sessionId = sessionId.session_id
                    self?.openUserInfo()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    //MARK: - Actions

    @objc private func loginUser() {
        validateUser()
    }
    
    func openUserInfo() {
        let vc = UserInfoViewController(sessionId: sessionId)
        navigationController?.pushViewController(vc, animated: true)
    }
}

