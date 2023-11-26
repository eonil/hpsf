import SwiftUI
import HPSFImpl1

struct HPTradeView: View {
    var bridge: HPBridge
    @State private var pageStack = [Page.productList]
    var body: some View {
        HPTradeProductListPage(bridge: bridge)
//        HPNavigationStack(pageStack: $pageStack) { page in
//            switch page {
//            case .productList: HPTradeProductListPage(bridge: bridge)
//            case .orderForm: HPTradeOrderFormView(bridge: bridge)
//            }
//        }
////        .onChange(of: bridge.data.navigation.tradeTab, syncPages)
//
//        //        HPNavigationView {
////            HPTradeProductListPage(bridge: bridge)
////        }
    }
    
    private enum Page {
        case productList
        case orderForm
    }
    
    private func syncPages() {
        switch bridge.data.navigation.tradeTab {
        case .productList:
            pageStack = [.productList]
        case .orderForm(let selectedProduct):
            pageStack = [.productList, .orderForm]
        }
    }
}
