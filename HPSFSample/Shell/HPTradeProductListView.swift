import SwiftUI
import HPSF

struct HPTradeProductListPage: View {
    var bridge: HPBridge
    var body: some View {
        HPConditionallyUpdatedView(condition: bridge.data.navigation.selectedTab == .trade) {
            let _ = print("render: \(#fileID)")
            let symbols = bridge.data.repo.memo.$marketPSwapSymbolDisplayOrder.timeline.transactions.last!.point.snapshot
            HPVersionBasedEquatableView(version: bridge.data.repo.market.$pswapTable.version) {
                HPLazyListView(data: symbols, cellHeight: 50) { symbol in
                    if let data = bridge.data.repo.market.pswapTable[symbol] {
                        let model = Cell.Model(code: data.symbol.code)
                        EquatableView(content: Cell(
                            bridge: bridge,
                            model: model,
                            action: HP.bind(pushOrderForm(with:), data.symbol)))
                    }
                }
            }
        }
    }
    
    private var isVisible: Bool {
        bridge.data.navigation.selectedTab == .trade && bridge.data.navigation.tradeTab.isProductList
    }
    
    private func pushOrderForm(with symbol: HPPSwapSymbol) {
        var n = bridge.data.navigation
        n.tradeTab = .orderForm(selectedProduct: symbol)
        bridge.queue(.navigation(n))
    }
    
    struct Cell: View, Equatable {
        var bridge: HPBridge
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
                NavigationLink {
                    HPTradeOrderFormView(bridge: bridge)
                } label: {
                    HPText(model.code, width: 100, height: 50)
                }

            }
        }
    }
}

#Preview {
    HPTradeProductListPage(bridge: HPBridge())
}
