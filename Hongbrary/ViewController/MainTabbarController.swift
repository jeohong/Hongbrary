//
//  ViewController.swift
//  Hongbrary
//
//  Created by 홍정민 on 2023/04/14.
//

import UIKit

class MainTabbarController: UITabBarController {
    private lazy var allBooksViewController: UINavigationController = {
        let allBooksViewController = AllBooksViewController()
        
        let tabBarItem = UITabBarItem(title: "책", image: UIImage(systemName: "books.vertical.fill")?.withTintColor(.red), tag: 0)
        allBooksViewController.tabBarItem = tabBarItem
        
        let navigationViewController = UINavigationController(rootViewController: allBooksViewController)
        
        return navigationViewController
    }()
    
    private lazy var readBooksViewController: UINavigationController = {
        let readBooksViewController = ReadBooksViewController()
        
        let tabBarItem = UITabBarItem(title: "내책", image: UIImage(systemName: "book.fill"), tag: 1)
        readBooksViewController.tabBarItem = tabBarItem
        
        let navigationViewController = UINavigationController(rootViewController: readBooksViewController)
        
        return navigationViewController
    }()
    
    private lazy var settingViewController: UINavigationController = {
        let settingViewController = SettingViewController()
        
        let tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gear"), tag: 2)
        settingViewController.tabBarItem = tabBarItem
        
        let navigationViewController = UINavigationController(rootViewController: settingViewController)
        
        return navigationViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [allBooksViewController, readBooksViewController, settingViewController]
        configureTabBar()
    }
    
    func configureTabBar() {
        self.tabBar.tintColor = .black
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.layer.masksToBounds = true
        self.tabBar.layer.backgroundColor = UIColor.white.cgColor
        self.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        self.tabBar.layer.borderWidth = 0.4
    }
}
