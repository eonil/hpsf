import SwiftUI

struct HPTradeView: View {
    var bridge: HPBridge
    var body: some View {
        HPTradeContentView(bridge: bridge)
    }
}

struct HPTradeContentView: View {
    var bridge: HPBridge
    var body: some View {
//        let ks = HPLazySetList(base: bridge.data.market.pswapSymbolIndex)
        let ks = Array(bridge.data.market.pswapSymbolIndex)
//        HPVersionBasedEquatableView(version: bridge.data.market.$pswapTable.version) {
            HPLazyListView(data: ks, cellHeight: 50) { symbol in
//                HPText(symbol.code)
                Color.yellow.frame(width: 20, height: 20, alignment: .center)
            }
//        }
    }
}

#Preview {
    HPTradeContentView(bridge: HPBridge())
}
