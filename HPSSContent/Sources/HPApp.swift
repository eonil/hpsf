import SwiftUI

@main
struct HPApp: App {
    init() {
        Task(operation: runKernel)
    }
    var body: some Scene {
        WindowGroup {
            HPRootView()
        }
    }
}

@Sendable
@HPCoreRun
private func runKernel() async {
    await HPKernel.shared.run()
}
