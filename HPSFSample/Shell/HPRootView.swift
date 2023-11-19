import SwiftUI

struct HPRootView: View {
    @State private var bridge = HPBridge()
    var body: some View {
        HPMainView(bridge: bridge).task(run)
    }
    
    @Sendable
    @HPCoreRun
    private func run() async {
        bridge.queue = { action in
            Task { @HPCoreRun in
                switch action {
                case let .command(x): HPKernel.shared.apply(x)
                case let .navigation(n): bridge.data.navigation = n
                }
            }
        }
    STEP:
        do {
            await HPKernel.shared.wait()
            bridge.data.repo = HPKernel.shared.snapshot()
            continue STEP
        }
    }
}
