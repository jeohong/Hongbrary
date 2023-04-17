//
//  UIApplication+.swift
//  Hongbrary
//
//  Created by 홍정민 on 2023/04/17.
//

import UIKit

extension UIApplication {
    /// RootViewController 변경
    func changeRoot(_ viewController: UIViewController) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        
        let firstWindow = windowScenes?.windows.filter { $0.isKeyWindow }.first
        
        firstWindow?.rootViewController = viewController
        firstWindow?.makeKeyAndVisible()
    }
}
