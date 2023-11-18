import SwiftUI

struct HPRootView: View {
    @State private var bridge = HPBridge(queue: noop, data: HPRepo())
    var body: some View {
        HPMainView(bridge: bridge).task(run)
//        EmptyView()
    }
    
    @Sendable
    @HPCoreRun
    private func run() async {
    STEP:
        do {
            await HPKernel.shared.wait()
            let rendition = HPKernel.shared.snapshot()
            bridge = HPBridge(
                queue: { action in
                    Task { @HPCoreRun in
                        HPKernel.shared.apply(action)
                    }
                },
                data: rendition)
            continue STEP
        }
    }
}
