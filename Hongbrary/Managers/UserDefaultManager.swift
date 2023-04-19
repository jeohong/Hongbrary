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
    
    func updateItem(_ item: String, forKey: String) {
        var storedArray = self.getList(forKey: forKey)
        
        let indexOfItem = storedArray.firstIndex(of: item)
        if indexOfItem == nil {
            storedArray.append(item)
            userDefaults.set(storedArray, forKey: forKey)
        }
    }
    
    func deleteItem(_ item: String, forKey: String) {
        var storedArray = self.getList(forKey: forKey)
        
        let indexOfItem = storedArray.firstIndex(of: item)
        guard let indexOfItem = indexOfItem else { return }
        storedArray.remove(at: indexOfItem)
        
        userDefaults.set(storedArray, forKey: forKey)
    }
    
    func getList(forKey: String) -> [String] {
        return userDefaults.object(forKey: forKey) as? [String] ?? []
    }
}
