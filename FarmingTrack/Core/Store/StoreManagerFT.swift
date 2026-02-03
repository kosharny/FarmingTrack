import Foundation
import StoreKit
import Combine

enum PurchaseResultFT {
    case success
    case cancelled
    case pending
    case failure(String)
}

@MainActor
final class StoreManagerFT: ObservableObject {

    // MARK: - Published
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs: Set<String> = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Config
    private let productIDs: [String]

    // MARK: - Init
    init(productIDs: [String]) {
        self.productIDs = productIDs
        loadLocalPurchases()

        Task {
            await listenForTransactions()
            await refreshPurchasedProducts()
            await loadProducts()
        }
    }

    // MARK: - Products
    func loadProducts() async {
        guard products.isEmpty else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let loaded = try await Product.products(for: productIDs)
            products = loaded.sorted { $0.price < $1.price }
        } catch {
            errorMessage = "Failed to load products"
        }
    }

    // MARK: - Purchase
    func purchase(_ product: Product) async -> PurchaseResultFT {
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                guard case .verified(let transaction) = verification else {
                    errorMessage = "Transaction not verified"
                    return .failure("Transaction not verified")
                }

                purchasedProductIDs.insert(transaction.productID)
                await transaction.finish()
                saveLocalPurchases()
                return .success

            case .userCancelled:
                return .cancelled

            case .pending:
                return .pending

            @unknown default:
                return .failure("Unknown purchase result")
            }

        } catch {
            errorMessage = "Purchase failed"
            return .failure(error.localizedDescription)
        }
    }

    // MARK: - Restore
    func restore() async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await AppStore.sync()
        } catch {
            errorMessage = "Restore failed"
        }
    }

    // MARK: - Entitlements
    private func refreshPurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
            }
        }
        saveLocalPurchases()
    }

    private func listenForTransactions() async {
        for await result in Transaction.updates {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
                await transaction.finish()
                saveLocalPurchases()
            }
        }
    }

    // MARK: - Local cache
    private func loadLocalPurchases() {
        let ids = UserDefaults.standard.stringArray(forKey: "purchasedProductIDs") ?? []
        purchasedProductIDs = Set(ids)
    }

    private func saveLocalPurchases() {
        UserDefaults.standard.set(Array(purchasedProductIDs), forKey: "purchasedProductIDs")
    }

    // MARK: - Helpers
    func isPurchased(_ id: String) -> Bool {
        purchasedProductIDs.contains(id)
    }

    func product(for id: String) -> Product? {
        products.first { $0.id == id }
    }
    
    nonisolated func paymentQueue(_ queue: SKPaymentQueue,
                                  shouldAddStorePayment payment: SKPayment,
                                  for product: SKProduct) -> Bool {
        return true
    }
}

