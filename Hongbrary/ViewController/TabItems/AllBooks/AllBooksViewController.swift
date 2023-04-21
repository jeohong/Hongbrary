//
//  AllBooksViewController.swift
//  Hongbrary
//
//  Created by 홍정민 on 2023/04/14.
//

import UIKit
import StoreKit

class AllBooksViewController: UIViewController {
    let pdfList = PdfList()
    let userDefault = UserDefaultManager.shared
    var products = [SKProduct]()
    
    private lazy var allBooksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        
        let intervar: CGFloat = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: intervar, bottom: 0, right: intervar)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BooksCollectionViewCell.self, forCellWithReuseIdentifier: BooksCollectionViewCell.cellId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    let progressBar: UIActivityIndicatorView = {
       let progress = UIActivityIndicatorView()
        progress.style = .whiteLarge
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.startAnimating()
        progress.isHidden = true
        
        return progress
    }()
    
    let backGround: UIView = {
        let view = UIView()
        view.isHidden = true
        view.layer.opacity = 0.7
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        getProduct()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePurchaseNoti(_:)),
            name: .iapServicePurchaseNotification,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.allBooksCollectionView.reloadData()
    }
    
    func setupLayout() {
        self.view.backgroundColor = .white
        self.title = "모든 책"
        
        self.view.addSubview(allBooksCollectionView)
        NSLayoutConstraint.activate([
            allBooksCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            allBooksCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            allBooksCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            allBooksCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        self.view.addSubview(backGround)
        NSLayoutConstraint.activate([
            backGround.topAnchor.constraint(equalTo: self.view.topAnchor),
            backGround.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            backGround.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backGround.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        ])
        
        self.view.addSubview(progressBar)
        NSLayoutConstraint.activate([
            progressBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            progressBar.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    func getProduct() {
        MyProducts.iapService.getProducts { success, products in
            if success, let products = products {
                self.products = products
            }
        }
    }
    
    func buyTheBook() {
        let alert = UIAlertController(title: "유료 도서 구매", message: "\(self.products[0].price)원에 구입하시겠습니까?\n구입이력이 있는경우 추가결제가 되지 않습니다.", preferredStyle: .alert)
        let buyAction = UIAlertAction(title: "구입", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.progressBar.isHidden = false
            self.backGround.isHidden = false
            MyProducts.iapService.buyProduct(self.products[0])
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(buyAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func subscriptBook(_ index: Int) {
        userDefault.updateItem(pdfList.itemList[index], forKey: ForKeys.myBooks.rawValue)
        self.tabBarController?.selectedIndex = 1
    }
    
    @objc
    private func handlePurchaseNoti(_ notification: Notification) {
        self.progressBar.isHidden = true
        self.backGround.isHidden = true
        self.allBooksCollectionView.reloadData()
        
        let index = self.pdfList.itemList.firstIndex(of: "swift_practice")
        if let index = index {
            subscriptBook(index)
        }
    }
}

extension AllBooksViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if pdfList.itemList[indexPath.row] == "swift_practice" {
            if userDefault.getPurchaseHistory(MyProducts.productID) {
                subscriptBook(indexPath.row)
            } else {
                buyTheBook()
            }
        } else {
            subscriptBook(indexPath.row)
        }
    }
}

extension AllBooksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pdfList.itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BooksCollectionViewCell.cellId, for: indexPath) as? BooksCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.pdfImage.image = UIImage(named: pdfList.itemList[indexPath.row])
        cell.titleLabel.text = pdfList.titleMap(pdfList.itemList[indexPath.row])
        
        if pdfList.itemList[indexPath.row] == "swift_practice" {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if self.userDefault.getPurchaseHistory(MyProducts.productID) {
                    cell.priceLabel.isHidden = true
                    cell.opacityView.isHidden = true
                } else {
                    cell.priceLabel.isHidden = false
                    cell.opacityView.isHidden = false
                }
            }
        }
        
        return cell
    }
}

extension AllBooksViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 30 * 3) / 3
        let height = (UIScreen.main.bounds.height) / 5
        
        return CGSize(width: width, height: height)
    }
}
