import SwiftUI

struct HPMainView: View {
    var bridge: HPBridge
    @State private var selectedTabID = TabID.trade
    private enum TabID {
        case trade
        case asset
    }
    var body: some View {
        TabView(selection: $selectedTabID) {
            HPTradeView(bridge: bridge).tag(TabID.trade).tabItem { tradeTabButtonContent }
            HPAssetView(bridge: bridge).tag(TabID.asset).tabItem { assetTabButtonContent }
        }
    }
    
    private var tradeTabButtonContent: some View {
        Text("Trade")
    }
    private var assetTabButtonContent: some View {
        Text("Asset")
    }
}
