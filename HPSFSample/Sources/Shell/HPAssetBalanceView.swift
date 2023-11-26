import SwiftUI
import HPSFImpl1

struct HPAssetBalaceView: View {
    var bridge: HPBridge
    @State private var isExpanded = false
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            ZStack {
                StaticBackgroundView()
                DynamicContentView(total: total())
            }
        } 
        label: {
            Text("Balance")
        }
    }
    
    private func total() -> HPDecimal {
        bridge.data.repo.market.pswapTable.values.lazy.map(\.lastPrice).reduce(0, +)
    }
}

private extension HPAssetBalaceView {
    struct StaticBackgroundView: View {
        var body: some View {
            let _ = print("re-render! static")
            VStack(spacing: 10) {
                HStack {
                    HPText("Total", width: 100, height: 50)
                    Spacer()
                }
                HStack {
                    HPText("Total", width: 100, height: 50)
                    Spacer()
                }
                HStack {
                    HPText("Total", width: 100, height: 50)
                    Spacer()
                }
            }
        }
    }
    
    struct DynamicContentView: View {
        var total: HPDecimal
        var body: some View {
            VStack(spacing: 10) {
                HStack {
                    Spacer()
                    HPText(total.description, width: 100, height: 50)
                }
                HStack {
                    Spacer()
                    HPText(total.description, width: 100, height: 50)
                }
                HStack {
                    Spacer()
                    HPText(total.description, width: 100, height: 50)
                }
            }
        }
    }
}
