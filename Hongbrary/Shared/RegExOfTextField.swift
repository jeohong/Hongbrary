//
//  RegExOfTextField.swift
//  Hongbrary
//
//  Created by 홍정민 on 2023/04/17.
//

import Foundation

class RegExOfTextField {
    /// Email 유효성 검사
    func checkEmail(email: String) -> Bool {
        let check = "([0-9a-zA-Z_-]+)@([0-9a-zA-Z_-]+)(\\.[0-9a-zA-Z_-]+){1,2}"
        return NSPredicate(format: "SELF MATCHES %@", check).evaluate(with: email)
    }
    
    /// Password 유효성 검사
    func checkPassword(password: String) -> Bool {
        let check = "^(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9])(?=.*[0-9]).{6,20}$"
        return NSPredicate(format: "SELF MATCHES %@", check).evaluate(with: password)
    }
    
    /// Password 가 일치하는지에 대한 유효성 검사
    func checkRewritePassword(existingPassword: String, rewritePassword: String) -> Bool {
        return existingPassword == rewritePassword
    }
}
