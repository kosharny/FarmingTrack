import SwiftUI

@main
struct FarmingTrackApp: App {
    @StateObject private var viewModel = MainViewModelFT()
    
    var body: some Scene {
        WindowGroup {
            RootViewFT()
                .environmentObject(viewModel)
        }
    }
}
