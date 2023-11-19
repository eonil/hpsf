import SwiftUI
import HPSF

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
                    let model = Cell.Model(code: data.symbol.code)
                    EquatableView(content: Cell(model: model, action: test1))
                }
            }
        }
    }
    
    private func test1() {
        var n = bridge.data.navigation
        n.tab = .asset
        bridge.queue(.navigation(n))
    }
    
    struct Cell: View, Equatable {
        /// Separated & minimized view-model is necessary to optimize performance.
        var model: Model
        struct Model: Equatable {
            var code: String
        }
        var action: () -> Void
        static func == (_ a: Self, _ b: Self) -> Bool {
            a.model == b.model
        }
        
        var body: some View {
            let _ = print("Trade tab item cell rendering triggered!")
//            ForEach(0..<100) { i in
//                HPText(data.symbol.code, width: 100, height: 50)
//            }
            
            ZStack {
                Color.blue.frame(height: 20)
                Button(action: action) {
                    HPText(model.code, width: 100, height: 50)
                }
            }
        }
    }
}

#Preview {
    HPTradeContentView(bridge: HPBridge())
}
