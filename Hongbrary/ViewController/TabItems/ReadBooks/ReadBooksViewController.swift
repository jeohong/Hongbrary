//
//  ReadBooksViewController.swift
//  Hongbrary
//
//  Created by 홍정민 on 2023/04/14.
//

import UIKit

class ReadBooksViewController: UIViewController {
    let pdfList = PdfList()
    let userDefault = UserDefaultManager.shared
    
    var items: [String] = []
    
    private lazy var myBooksCollectionView: UICollectionView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupLongGestureRecognizerOnCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionViewReload()
    }
    
    func setupLayout() {
        self.view.backgroundColor = .white
        self.title = "구독중인 책 목록"
        
        self.view.addSubview(myBooksCollectionView)
        NSLayoutConstraint.activate([
            myBooksCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            myBooksCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            myBooksCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            myBooksCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func collectionViewReload() {
        items = userDefault.getUserDefault()
        self.myBooksCollectionView.reloadData()
    }
    
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        myBooksCollectionView.addGestureRecognizer(longPressedGesture)
    }

    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }

        let p = gestureRecognizer.location(in: myBooksCollectionView)

        if let indexPath = myBooksCollectionView.indexPathForItem(at: p) {
            let alert = UIAlertController(title: "책 삭제", message: "구독중인 책 목록에서 삭제하시겠습니까?", preferredStyle: .alert)
            let removeAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                self.userDefault.deleteItem(self.items[indexPath.row])
                
                self.collectionViewReload()
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(removeAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
}

extension ReadBooksViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 클릭시 PDF 다운로드 or 다운로드 된 상태면 PDF 열기
    }
}

extension ReadBooksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BooksCollectionViewCell.cellId, for: indexPath) as? BooksCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.pdfImage.image = UIImage(named: items[indexPath.row])
        cell.titleLabel.text = pdfList.titleMap(items[indexPath.row])
        
        return cell
    }
}

extension ReadBooksViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 30 * 3) / 3
        let height = (UIScreen.main.bounds.height) / 5
        
        return CGSize(width: width, height: height)
    }
}

extension ReadBooksViewController: UIGestureRecognizerDelegate {
    
}
