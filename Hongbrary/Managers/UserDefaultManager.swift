//
//  UserDefaultManager.swift
//  Hongbrary
//
//  Created by 홍정민 on 2023/04/18.
//

import Foundation

class UserDefaultManager {
    static let shared = UserDefaultManager()
    
    let userDefaults = UserDefaults.standard
    let forKey = "myBooks"
    lazy var storedArray = self.getUserDefault()
    
    func updateItem(_ item: String) {
        let indexOfItem = storedArray.firstIndex(of: item)
        if indexOfItem == nil {
            storedArray.append(item)
            userDefaults.set(storedArray, forKey: forKey)
        }
    }
    
    func deleteItem(_ item: String) {
        let indexOfItem = storedArray.firstIndex(of: item)
        
        guard let indexOfItem = indexOfItem else { return }
        storedArray.remove(at: indexOfItem)
        
        userDefaults.set(storedArray, forKey: forKey)
    }
    
    func getUserDefault() -> [String] {
        return userDefaults.object(forKey: self.forKey) as? [String] ?? []
    }
}
