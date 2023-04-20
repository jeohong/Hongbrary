//
//  IAPManager.swift
//  Hongbrary
//
//  Created by 홍정민 on 2023/04/20.
//
//

import StoreKit

typealias ProductsRequestCompletion = (_ success: Bool, _ products: [SKProduct]?) -> Void

protocol IAPManagerType {
    var canMakePayments: Bool { get }
    
    func getProducts(completion: @escaping ProductsRequestCompletion)
    func buyProduct(_ product: SKProduct)
    func isProductPurchased(_ productID: String) -> Bool
    func restorePurchases()
}

class IAPManager: NSObject {
    private let productIDs: Set<String>
    private var purchasedProductIDs: Set<String>
    private var productsRequest: SKProductsRequest?
    private var productsCompletion: ProductsRequestCompletion?
    
    init(productIDs: Set<String>) {
        self.productIDs = productIDs
        self.purchasedProductIDs = productIDs
            .filter { UserDefaults.standard.bool(forKey: $0) == true }
        
        super.init()
        SKPaymentQueue.default().add(self)
    }
}

// MARK: SKProductsRequestDelegate 
extension IAPManager: SKProductsRequestDelegate {
    // didReceive
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        self.productsCompletion?(true, products)
        self.clearRequestAndHandler()
        
        products.forEach { print("Found product: \($0.productIdentifier) \($0.localizedTitle) \($0.price.floatValue)") }
    }
    
    // failed
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Erorr: \(error.localizedDescription)")
        self.productsCompletion?(false, nil)
        self.clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        self.productsRequest = nil
        self.productsCompletion = nil
    }
}

// MARK: Delegate 패턴
extension IAPManager: IAPManagerType {
    var canMakePayments: Bool {
        SKPaymentQueue.canMakePayments()
    }
    
    func getProducts(completion: @escaping ProductsRequestCompletion) {
        self.productsRequest?.cancel()
        self.productsCompletion = completion
        self.productsRequest = SKProductsRequest(productIdentifiers: self.productIDs)
        self.productsRequest?.delegate = self
        self.productsRequest?.start()
    }
    
    func buyProduct(_ product: SKProduct) {
        SKPaymentQueue.default().add(SKPayment(product: product))
    }
    
    func isProductPurchased(_ productID: String) -> Bool {
        self.purchasedProductIDs.contains(productID)
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: In-App 옵저버
extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach {
            switch $0.transactionState {
            case .purchased:
                // 구입 완료
                print("completed transaction")
                self.deliverPurchaseNotificationFor(id: $0.original?.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction($0)
            case .failed:
                // 구입 실패
                if let transactionError = $0.error as NSError?,
                   let description = $0.error?.localizedDescription,
                   transactionError.code != SKError.paymentCancelled.rawValue {
                    print("Transaction erorr: \(description)")
                }
                SKPaymentQueue.default().finishTransaction($0)
            case .restored:
                // 이미 구매한 목록
                print("restored Transaction")
                self.deliverPurchaseNotificationFor(id: $0.original?.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction($0)
                
                // UserDefault 값 조회
                print(UserDefaults.standard.bool(forKey: $0.original?.payment.productIdentifier ?? ""))
            case .deferred:
                print("deferred")
            case .purchasing:
                // 구입중
                print("purchasing")
            default:
                print("unknown")
            }
        }
    }
    
    private func deliverPurchaseNotificationFor(id: String?) {
        guard let id = id else { return }
        
        self.purchasedProductIDs.insert(id)
        UserDefaults.standard.set(true, forKey: id)
        NotificationCenter.default.post(
            name: .iapServicePurchaseNotification,
            object: id
        )
    }
}

// MARK: In-App 관련 Enum
enum MyProducts {
  static let productID = "com.tomato.test.newstong.buybooks"
  static let iapService: IAPManagerType = IAPManager(productIDs: Set<String>([productID]))
  
  static func getResourceProductName(_ id: String) -> String? {
    id.components(separatedBy: ".").last
  }
}

extension Notification.Name {
  static let iapServicePurchaseNotification = Notification.Name("IAPServicePurchaseNotification")
}
