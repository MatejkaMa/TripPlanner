import SwiftUI
import TUIService

@main
struct Trip_PlannnerApp: App {

    let tuiService: TUIMobilityHubServiceProtocol

    init() {
        self.tuiService = TUIMobilityHubService()
    }

    var body: some Scene {
        WindowGroup {
            RootScreenView<RootScreenViewModel>(viewModel: .init(tuiService: tuiService))
        }
    }
}
