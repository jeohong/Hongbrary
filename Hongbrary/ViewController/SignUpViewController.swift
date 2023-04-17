//
//  SignUpViewController.swift
//  Hongbrary
//
//  Created by 홍정민 on 2023/04/17.
//

import UIKit

class SignUpViewController: UIViewController {
    let regExOfTextField = RegExOfTextField()
    let firebasemanager = FirebaseAuthManager.shared
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
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
            self.checkEmailLabel.isHidden = (self.regExOfTextField.checkEmail(email: textField.text ?? "") || textField.text == "")
            self.configureSignupButton()
            
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
            self.checkPasswordLabel.isHidden = (self.regExOfTextField.checkPassword(password: textField.text ?? "") || textField.text == "")
            self.configureSignupButton()
            
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
    
    private let rewritePasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호를 다시 입력해주세요."
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var rewritePasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Rewrite Password"
        textField.isSecureTextEntry = true
        textField.addLeftPadding()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 15
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.delegate = self
        textField.addAction(UIAction(handler: { _ in
            self.checkRewritePasswordLabel.isHidden = (self.regExOfTextField.checkRewritePassword(existingPassword: self.passwordTextField.text ?? "",
                                                                                                  rewritePassword: textField.text ?? "") || textField.text == "")
            
            self.configureSignupButton()
        }), for: .editingChanged)
        
        return textField
    }()
    
    private let checkRewritePasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "* 비밀번호가 일치하지 않습니다."
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        
        return label
    }()
    
    private lazy var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("계정생성", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.red, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.isEnabled = false
        
        button.addAction(UIAction(handler: { _ in
            self.pressedSignupButton()
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        
        button.addAction(UIAction(handler: { _ in
            self.dismiss(animated: true)
        }), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        
        self.view.addSubview(rewritePasswordLabel)
        NSLayoutConstraint.activate([
            rewritePasswordLabel.leadingAnchor.constraint(equalTo: self.emailLabel.leadingAnchor),
            rewritePasswordLabel.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 30)
        ])
        
        self.view.addSubview(rewritePasswordTextField)
        NSLayoutConstraint.activate([
            rewritePasswordTextField.leadingAnchor.constraint(equalTo: self.emailLabel.leadingAnchor),
            rewritePasswordTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            rewritePasswordTextField.topAnchor.constraint(equalTo: self.rewritePasswordLabel.bottomAnchor, constant: 5),
            rewritePasswordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        self.view.addSubview(checkRewritePasswordLabel)
        NSLayoutConstraint.activate([
            checkRewritePasswordLabel.leadingAnchor.constraint(equalTo: self.rewritePasswordTextField.leadingAnchor),
            checkRewritePasswordLabel.topAnchor.constraint(equalTo: self.rewritePasswordTextField.bottomAnchor, constant: 2)
        ])
        
        self.view.addSubview(signupButton)
        NSLayoutConstraint.activate([
            signupButton.topAnchor.constraint(equalTo: self.rewritePasswordTextField.bottomAnchor, constant: 30),
            signupButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            signupButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            signupButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: self.signupButton.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            cancelButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            cancelButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureSignupButton() {
        self.signupButton.setTitle("계정생성", for: .normal)
        self.cancelButton.isHidden = false
        
        if (self.checkEmailLabel.isHidden && self.checkPasswordLabel.isHidden && self.checkRewritePasswordLabel.isHidden) &&
            (self.emailTextField.text != "") &&
            (self.passwordTextField.text != "") &&
            (self.rewritePasswordTextField.text != "") {
            self.signupButton.isEnabled = true
            self.signupButton.setTitleColor(.black, for: .normal)
        } else {
            self.signupButton.isEnabled = false
            self.signupButton.setTitleColor(.red, for: .normal)
        }
    }
    
    func pressedSignupButton() {
        signupButton.isEnabled = false
        signupButton.setTitle("계정 생성중...", for: .normal)
        signupButton.setTitleColor(.gray, for: .normal)
        cancelButton.isHidden = true
        
        firebasemanager.signup(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "") { [weak self] error in
            guard let error = error else {
                self?.dismiss(animated: true)
                return
            }
            self?.presentSignupErrorAlert(errorCode: error.code)
        }
    }
    
    func presentSignupErrorAlert(errorCode: Int) {
        var errorMessage: String = ""
        
        switch errorCode {
        case 17007:
            errorMessage = "이미 가입된 이메일입니다."
        case 17020:
            errorMessage = "네트워크 상태를 확인해주세요."
        case 17008:
            errorMessage = "올바른 이메일 형식이 아닙니다."
        default:
            errorMessage = "다시 시도해 주세요"
        }
        
        let alert = UIAlertController(title: "회원가입 실패", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.configureSignupButton()
        }
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
