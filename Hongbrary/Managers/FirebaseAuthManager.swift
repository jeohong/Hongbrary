//
//  FirebaseAuthManager.swift
//  Hongbrary
//
//  Created by 홍정민 on 2023/04/17.
//

import Foundation
import FirebaseAuth
import UIKit

class FirebaseAuthManager {
    static let shared = FirebaseAuthManager()
    
    var currentUid = Auth.auth().currentUser?.uid
    
    func signIn(email: String, password: String, completion: @escaping (NSError?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            completion(error as NSError?)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
