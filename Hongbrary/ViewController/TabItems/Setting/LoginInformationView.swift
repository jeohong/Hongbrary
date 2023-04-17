//
//  LoginInformationView.swift
//  Hongbrary
//
//  Created by 홍정민 on 2023/04/17.
//

import UIKit

class LoginInformationView: UIView {
    private let loginInformationLabel: UILabel = {
        let loginInformationLabel = UILabel()
        loginInformationLabel.text = "로그인 정보"
        loginInformationLabel.font = UIFont.boldSystemFont(ofSize: 16)
        loginInformationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return loginInformationLabel
    }()
    
    let eMailLabel: UILabel = {
        let eMailLabel = UILabel()
        eMailLabel.font = UIFont.systemFont(ofSize: 13)
        eMailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return eMailLabel
    }()
    
    lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(loginInformationLabel)
        NSLayoutConstraint.activate([
            loginInformationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            loginInformationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
        
        addSubview(eMailLabel)
        NSLayoutConstraint.activate([
            eMailLabel.topAnchor.constraint(equalTo: loginInformationLabel.bottomAnchor, constant: 4),
            eMailLabel.leadingAnchor.constraint(equalTo: loginInformationLabel.leadingAnchor)
        ])
        
        addSubview(logOutButton)
        NSLayoutConstraint.activate([
            logOutButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            logOutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            logOutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            logOutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
