//
//  ReadBooksViewController.swift
//  Hongbrary
//
//  Created by 홍정민 on 2023/04/14.
//

import UIKit

class ReadBooksViewController: UIViewController {
    private let sampleLabel: UILabel = {
       let label = UILabel()
        label.text = "내책"
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    func setupLayout() {
        self.view.addSubview(sampleLabel)
        NSLayoutConstraint.activate([
            sampleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            sampleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}
