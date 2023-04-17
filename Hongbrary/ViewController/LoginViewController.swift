//
//  LoginViewController.swift
//  Hongbrary
//
//  Created by 홍정민 on 2023/04/17.
//

import UIKit

class LoginViewController: UIViewController {
    let regexClass = RegExOfTextField()
    
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
        textField.addAction(UIAction(handler: { _ in
            self.checkEmailLabel.isHidden = (self.regexClass.checkEmail(email: textField.text ?? "") || textField.text == "")
            
            self.configureLoginButton()
        }), for: .editingChanged)
        
        return textField
    }()
    
    private let checkEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "* 올바른 이메일을 입력하세요."
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        
        return label
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
        textField.addAction(UIAction(handler: { _ in
            self.checkPasswordLabel.isHidden = (self.regexClass.checkPassword(password: textField.text ?? "") || textField.text == "")
            
            self.configureLoginButton()
        }), for: .editingChanged)
        
        return textField
    }()
    
    private let checkPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "* 비밀번호는 영문, 숫자, 특수문자를 포함한 6-20자 사이입니다."
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.red, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.isEnabled = false
        
        button.addAction(UIAction(handler: { _ in
            // TODO: Firebase 연동하여 로그인 로직 구현 및 탭바뷰컨트롤러로 이동
            print("로그인 버튼 클릭")
        }), for: .touchUpInside)
        
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
        
        button.addAction(UIAction(handler: { _ in
            // TODO: 회원가입 View 로 이동
            print("회원가입 버튼 클릭")
        }), for: .touchUpInside)
        
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
        
        self.view.addSubview(checkEmailLabel)
        NSLayoutConstraint.activate([
            checkEmailLabel.leadingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor),
            checkEmailLabel.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 2)
        ])
        
        self.view.addSubview(passwordLabel)
        NSLayoutConstraint.activate([
            passwordLabel.leadingAnchor.constraint(equalTo: self.emailLabel.leadingAnchor),
            passwordLabel.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 30)
        ])
        
        self.view.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: self.emailLabel.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            passwordTextField.topAnchor.constraint(equalTo: self.passwordLabel.bottomAnchor, constant: 5),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        self.view.addSubview(checkPasswordLabel)
        NSLayoutConstraint.activate([
            checkPasswordLabel.leadingAnchor.constraint(equalTo: self.passwordTextField.leadingAnchor),
            checkPasswordLabel.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 2)
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
    
    func configureLoginButton() {
        if (self.checkEmailLabel.isHidden && self.checkPasswordLabel.isHidden) && (self.emailTextField.text != "") && (self.passwordTextField.text != "") {
            self.loginButton.isEnabled = true
            self.loginButton.setTitleColor(.black, for: .normal)
        } else {
            self.loginButton.isEnabled = false
            self.loginButton.setTitleColor(.red, for: .normal)
        }
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
