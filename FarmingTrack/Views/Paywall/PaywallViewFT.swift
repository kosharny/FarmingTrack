import SwiftUI
import StoreKit

struct PaywallViewFT: View {

    @ObservedObject var storeManager: StoreManagerFT
    let theme: MainViewModelFT.ThemeFT

    @EnvironmentObject var viewModel: MainViewModelFT
    @Environment(\.dismiss) private var dismiss

    private var product: Product? {
        guard let id = theme.productID else { return nil }
        return storeManager.product(for: id)
    }

    // Alert states
    @State private var showConfirmAlert = false
    @State private var showResultAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    private var priceString: String {
        product?.displayPrice ?? "—"
    }

    var body: some View {
        ZStack {
            MainBackgroundFT()
                .overlay(Color.black.opacity(0.6))

            VStack(spacing: 30) {
                Spacer()

                Image(systemName: "paintpalette.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color.FT.primaryYellow)
                    .shadow(color: Color.FT.primaryYellow.opacity(0.5), radius: 20)

                VStack(spacing: 10) {
                    Text("Unlock \(theme.displayName)")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text("Customize your farming experience with this premium theme.")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                GameCardFT {
                    HStack {
                        Text(theme.displayName)
                            .foregroundColor(.white)
                        Spacer()
                        if let product {
                            Text(product.displayPrice)
                                .foregroundColor(Color.FT.primaryYellow)
                        } else {
                            ProgressView().tint(.white)
                        }
                    }
                    .padding()
                }
                .padding(.horizontal)

                Spacer()

                VStack(spacing: 16) {
                    PrimaryButtonFT(
                        title: product != nil ? "Purchase for \(priceString)" : "Loading…",
                        icon: "cart.fill"
                    ) {
                        guard let _ = product else { return }
                        alertTitle = "Confirm Purchase"
                        alertMessage = "Would you like to unlock the \(theme.displayName) theme for \(priceString)?"
                        showConfirmAlert = true
                    }
                    .disabled(product == nil || storeManager.isLoading)
                    .opacity(product == nil ? 0.6 : 1)

                    Button("Not Now") {
                        dismiss()
                    }
                    .foregroundColor(.white.opacity(0.6))
                }
                .padding(.bottom, 50)
                .padding(.horizontal)
            }

            if storeManager.isLoading {
                Color.black.opacity(0.5).ignoresSafeArea()
                ProgressView("Processing…")
                    .tint(.white)
            }
            
            if showConfirmAlert {
                CustomAlertFT(
                    title: alertTitle,
                    message: alertMessage,
                    primaryButton: AlertButtonFT(title: "Confirm", icon: "checkmark", action: {
                        showConfirmAlert = false
                        if let product = product {
                            Task {
                                let result = await storeManager.purchase(product)
                                handlePurchaseResult(result)
                            }
                        }
                    }),
                    secondaryButton: AlertButtonFT(title: "Cancel", action: {
                        showConfirmAlert = false
                    })
                )
            }
            
            if showResultAlert {
                CustomAlertFT(
                    title: alertTitle,
                    message: alertMessage,
                    primaryButton: AlertButtonFT(title: "OK", icon: "checkmark", action: {
                        showResultAlert = false
                        if alertTitle == "Success" {
                            dismiss()
                        }
                    })
                )
            }
        }
    }

    private func handlePurchaseResult(_ result: PurchaseResultFT) {
        switch result {
        case .success:
            viewModel.selectTheme(theme)
            alertTitle = "Success"
            alertMessage = "The \(theme.displayName) theme has been successfully unlocked!"
            showResultAlert = true
        case .failure(let error):
            alertTitle = "Purchase Error"
            alertMessage = error
            showResultAlert = true
        case .cancelled:
            // Do nothing for cancellation
            break
        case .pending:
            alertTitle = "Purchase Pending"
            alertMessage = "Your purchase is pending approval."
            showResultAlert = true
        }
    }
}

