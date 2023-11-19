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
        let symbols = bridge.data.repo.memo.$marketPSwapSymbolDisplayOrder.timeline.transactions.last!.point.snapshot
        HPVersionBasedEquatableView(version: bridge.data.repo.market.$pswapTable.version) {
            HPLazyListView(data: symbols, cellHeight: 50) { symbol in
                if let data = bridge.data.repo.market.pswapTable[symbol] {
                    EquatableView(content: Cell(data: data))
                }
            }
        }
    }
    
    struct Cell: View, Equatable {
        var data: HPPSwapDetail
        var body: some View {
            let _ = print("Trade tab item cell rendering triggered!")
//            ForEach(0..<100) { i in
//                HPText(data.symbol.code, width: 100, height: 50)
//            }
            
            ZStack {
                Color.blue.frame(height: 20)
                HPText(data.symbol.code, width: 100, height: 50)
            }
        }
    }
}

#Preview {
    HPTradeContentView(bridge: HPBridge())
}
