//
//  ReadBooksViewController.swift
//  Hongbrary
//
//  Created by 홍정민 on 2023/04/14.
//

import UIKit
import ZIPFoundation

class ReadBooksViewController: UIViewController {
    let pdfList = PdfList()
    let userDefault = UserDefaultManager.shared
    
    var items: [String] = []
    var downloadList: [String] = []
    var isDownloadingList: [String] = []
    
    lazy var session: URLSession = { [weak self] in
       return URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
    }()
    var downloadTask: URLSessionDownloadTask?
    
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
        items = userDefault.getList(forKey: ForKeys.myBooks.rawValue)
        downloadList = userDefault.getList(forKey: ForKeys.downloadBooks.rawValue)
        
        self.myBooksCollectionView.reloadData()
    }
    
    func openPdfViewer(_ index: Int) {
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let directoryPath = documentsPath.appendingPathComponent("Download Books/\(pdfList.originalFileName(items[index]))")
        
        let dc = UIDocumentInteractionController(url: directoryPath)
        dc.delegate = self
        dc.presentPreview(animated: true)
    }
}

// MARK: CollectionView Delegate & DataSource
extension ReadBooksViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = URL(string: "http://chk.newstong.co.kr/\(items[indexPath.row]).zip") else { return }
        
        if isDownloadingList.contains(items[indexPath.row]) {
            // Download 중일때 취소 로직
            let index = self.isDownloadingList.firstIndex(of: self.items[indexPath.row])
            self.isDownloadingList.remove(at: index!)
            collectionView.reloadData()
            
            downloadTask?.cancel()
        } else {
            if downloadList.contains(items[indexPath.row]) {
                // 다운로드 목록에 있다면 PDF 뷰어 오픈
                openPdfViewer(indexPath.row)
                
            } else {
                // 다운로드 목록에 없다면 다운로드 시작
                self.session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
                self.isDownloadingList.append(items[indexPath.row])
                collectionView.reloadData()
                downloadTask = session.downloadTask(with: url)
                downloadTask?.taskDescription = "\(indexPath.row)"
                
                downloadTask?.resume()
            }
        }
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
        
        if !downloadList.contains(items[indexPath.row]) {
            cell.opacityView.isHidden = false
        } else {
            cell.opacityView.isHidden = true
        }
        
        if !isDownloadingList.contains(items[indexPath.row]) {
            cell.progressBar.isHidden = true
        } else {
            cell.progressBar.isHidden = false
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

// MARK: LongPressGeusture Delegate
extension ReadBooksViewController: UIGestureRecognizerDelegate {
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
                self.userDefault.deleteItem(self.items[indexPath.row], forKey: ForKeys.myBooks.rawValue)
                self.userDefault.deleteItem(self.items[indexPath.row], forKey: ForKeys.downloadBooks.rawValue)
                
                let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                let directoryPath = documentsPath.appendingPathComponent("Download Books/\(self.pdfList.originalFileName(self.items[indexPath.row]))")
                do {
                    try? FileManager.default.removeItem(at: directoryPath)
                }
                
                self.collectionViewReload()
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(removeAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
}

// MARK: URLSession Delegate
extension ReadBooksViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let directoryPath = documentsPath.appendingPathComponent("Download Books")
        let tempPath = directoryPath.appendingPathComponent("__MACOSX")
        do {
            try FileManager.default.createDirectory(atPath: directoryPath.path, withIntermediateDirectories: false, attributes: nil)
        } catch let e as NSError {
            print(e.localizedDescription)
        }
        
        let destinationURL = directoryPath.appendingPathComponent(url.lastPathComponent)
        try? FileManager.default.removeItem(at: destinationURL)
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            try FileManager.default.unzipItem(at: destinationURL, to: directoryPath, preferredEncoding: .utf8)
            try? FileManager.default.removeItem(at: destinationURL)
            try? FileManager.default.removeItem(at: tempPath)
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
        
        if let row = Int(downloadTask.taskDescription ?? "") {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.userDefault.updateItem(self.items[IndexPath(row: row, section: 0)[1]], forKey: ForKeys.downloadBooks.rawValue)
                guard let index = self.isDownloadingList.firstIndex(of: self.items[IndexPath(row: row, section: 0)[1]]) else { return }
                self.isDownloadingList.remove(at: index)
                
                self.collectionViewReload()
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let row = Int(downloadTask.taskDescription ?? "") {
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let cell = self.myBooksCollectionView.cellForItem(at: IndexPath(row: row, section: 0)) as? BooksCollectionViewCell else { return }
                cell.progressBar.setProgress(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite), animated: true)
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let _ = error {
            session.invalidateAndCancel()
        }
    }
}

// MARK: PDF Viewer Delegate
extension ReadBooksViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let tempPath = documentsPath.appendingPathComponent("Download Books/(A Document Being Saved By Hongbrary)")
        
        do {
            try FileManager.default.removeItem(at: tempPath)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
