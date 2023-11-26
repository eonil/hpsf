struct HPNavigation {
    var selectedTab = Tab.asset
    enum Tab {
        case trade
        case challenge
        case asset
    }
    var tradeTab = TradeTab.productList
    enum TradeTab: Equatable {
        case productList
        case orderForm(selectedProduct: HPPSwapSymbol)
        var isProductList: Bool {
            switch self {
            case .productList: return true
            default: return false
            }
        }
        var isOrderForm: Bool {
            switch self {
            case .orderForm: return true
            default: return false
            }
        }
    }
}
