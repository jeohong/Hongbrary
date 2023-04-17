//
//  LoginViewController.swift
//  Hongbrary
//
//  Created by 홍정민 on 2023/04/17.
//

import UIKit

class LoginViewController: UIViewController {
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "서비스를 이용하기 위해서는\n로그인이 필요합니다."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일을 입력해주세요."
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.addLeftPadding()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 15
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.delegate = self
        
        return textField
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호를 입력해주세요."
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.addLeftPadding()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 15
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.delegate = self
        
        return textField
    }()
    
    private let loginButton: UIButton = {
       let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        
        return button
    }()
    
    private let signupButton: UIButton = {
       let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    func setupLayout() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
        self.view.addSubview(emailLabel)
        NSLayoutConstraint.activate([
            emailLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            emailLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 50)
        ])
        
        self.view.addSubview(emailTextField)
        NSLayoutConstraint.activate([
            emailTextField.leadingAnchor.constraint(equalTo: self.emailLabel.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            emailTextField.topAnchor.constraint(equalTo: self.emailLabel.bottomAnchor, constant: 5),
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        self.view.addSubview(passwordLabel)
        NSLayoutConstraint.activate([
            passwordLabel.leadingAnchor.constraint(equalTo: self.emailLabel.leadingAnchor),
            passwordLabel.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 20)
        ])
        
        self.view.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: self.emailLabel.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            passwordTextField.topAnchor.constraint(equalTo: self.passwordLabel.bottomAnchor, constant: 5),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        self.view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.view.addSubview(signupButton)
        NSLayoutConstraint.activate([
            signupButton.topAnchor.constraint(equalTo: self.loginButton.bottomAnchor, constant: 20),
            signupButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            signupButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            signupButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
