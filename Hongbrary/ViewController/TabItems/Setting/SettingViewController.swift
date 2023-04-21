//
//  SettingViewController.swift
//  Hongbrary
//
//  Created by 홍정민 on 2023/04/14.
//

import UIKit

class SettingViewController: UIViewController {
    let firebaseManager = FirebaseAuthManager.shared
    let userDefault = UserDefaultManager.shared
        
    private let loginInformationView: LoginInformationView = {
        let logInInformationView = LoginInformationView()
        logInInformationView.translatesAutoresizingMaskIntoConstraints = false
        logInInformationView.layer.cornerRadius = 15
        logInInformationView.backgroundColor = .white
        logInInformationView.layer.borderWidth = 1
        logInInformationView.layer.borderColor = UIColor.lightGray.cgColor
        
        return logInInformationView
    }()
    
    private lazy var restoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("유료구입 항목 복원", for: .normal)
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
        configureButtonsAction()
        setupUserData()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotbuyNoti(_:)),
            name: .iapServiceNotBuyUserNotification,
            object: nil
        )
    }
    
    func setupLayout() {
        self.view.backgroundColor = .white
        self.title = "설정"
        
        self.view.addSubview(loginInformationView)
        NSLayoutConstraint.activate([
            loginInformationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            loginInformationView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            loginInformationView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            loginInformationView.heightAnchor.constraint(equalToConstant: 195)
        ])
        
        self.view.addSubview(restoreButton)
        NSLayoutConstraint.activate([
            restoreButton.topAnchor.constraint(equalTo: self.loginInformationView.bottomAnchor, constant: 10),
            restoreButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            restoreButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            restoreButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureButtonsAction() {
        self.loginInformationView.logOutButton.addAction(UIAction(handler: { _ in
            self.firebaseManager.signOut()
            UIApplication.shared.changeRoot(LoginViewController())
        }), for: .touchUpInside)
        
        self.restoreButton.addAction(UIAction(handler: { _ in
            if !self.userDefault.getPurchaseHistory(MyProducts.productID) {
                MyProducts.iapService.restorePurchases()
            } else {
                let message = "이미 구입목록에 있습니다."
                self.failAlert(message)
            }
        }), for: .touchUpInside)
    }
    
    func setupUserData() {
        guard let email = firebaseManager.userEmail else { return }
        self.loginInformationView.eMailLabel.text = email
    }
    
    func failAlert(_ message: String) {
        let alert = UIAlertController(title: "요청 실패", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    @objc
    func handleNotbuyNoti(_ notification: Notification) {
        let message = "구입 이력이 없습니다."
        failAlert(message)
    }
}
