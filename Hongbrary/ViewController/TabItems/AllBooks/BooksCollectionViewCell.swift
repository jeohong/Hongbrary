//
//  BooksCollectionViewCell.swift
//  Hongbrary
//
//  Created by 홍정민 on 2023/04/17.
//

import UIKit

class BooksCollectionViewCell: UICollectionViewCell {
    static let cellId = "BooksCollectionViewCell"
    
    let opacityView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.6
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let progressBar: UIProgressView = {
       let progress = UIProgressView()
        progress.trackTintColor = .black
        progress.progressTintColor = .white
        progress.progressViewStyle = .bar
        progress.progress = 0
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.isHidden = true
        
        return progress
    }()
    
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
    
    let priceLabel: UILabel = {
       let label = UILabel()
        label.text = "유료 도서"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        
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
        
        self.contentView.addSubview(opacityView)
        NSLayoutConstraint.activate([
            opacityView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            opacityView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            opacityView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            opacityView.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        ])
        
        self.contentView.addSubview(progressBar)
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            progressBar.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            progressBar.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        ])
        
        self.contentView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            priceLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
}
