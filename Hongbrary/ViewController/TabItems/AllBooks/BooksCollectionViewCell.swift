//
//  BooksCollectionViewCell.swift
//  Hongbrary
//
//  Created by 홍정민 on 2023/04/17.
//

import UIKit

class BooksCollectionViewCell: UICollectionViewCell {
    static let cellId = "BooksCollectionViewCell"
    
    let pdfImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        self.contentView.addSubview(pdfImage)
        NSLayoutConstraint.activate([
            pdfImage.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            pdfImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            pdfImage.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            pdfImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20)
        ])
        
        self.contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
}
