import SwiftUI

struct HPTradeView: View {
    var bridge: HPBridge
    var body: some View {
        HPConditionallyUpdatedView(condition: bridge.data.navigation.tab == .trade) {
            let _ = print("Trade tab content rendering triggered!")
            HPTradeContentView(bridge: bridge)
        }
    }
}

struct HPTradeContentView: View {
    var bridge: HPBridge
    var body: some View {
        let ks = HPLazySetList(base: bridge.data.repo.market.pswapSymbolIndex)
        HPVersionBasedEquatableView(version: bridge.data.repo.market.$pswapTable.version) {
            HPLazyListView(data: ks, cellHeight: 50) { symbol in
                HPText(symbol.code, width: 100, height: 50)
            }
        }
    }
}

#Preview {
    HPTradeContentView(bridge: HPBridge())
}
