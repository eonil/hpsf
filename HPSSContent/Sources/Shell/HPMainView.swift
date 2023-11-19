import SwiftUI

struct HPMainView: View {
    var bridge: HPBridge
    var body: some View {
        VStack {
            ZStack {
                HPConditionallyVisibleView(condition: bridge.data.navigation.tab == .trade) {
                    HPTradeView(bridge: bridge).tag(HPNavigation.Tab.trade)
                }
                HPConditionallyVisibleView(condition: bridge.data.navigation.tab == .challenge) {
                    HPChallengeView(bridge: bridge).tag(HPNavigation.Tab.challenge)
                }
                HPConditionallyVisibleView(condition: bridge.data.navigation.tab == .asset) {
                    HPAssetView(bridge: bridge).tag(HPNavigation.Tab.asset)
                }
            }
            HStack {
                tradeTabButton
                challengeTabButton
                assetTabButton
            }
        }
        
//        TabView(selection: $selectedTabID) {
//            HPTradeView(bridge: bridge).tag(TabID.trade).tabItem { tradeTabButtonContent }
//            HPChallengeView(bridge: bridge).tag(TabID.challenge).tabItem { challengeTabButtonContent }
//            HPAssetView(bridge: bridge).tag(TabID.asset).tabItem { assetTabButtonContent }
//        }
    }
    
    private var tradeTabButton: some View {
        Button(action: HP.bind(selectTab(_:), .trade)) {
            Text("Trade")
        }
    }
    private var challengeTabButton: some View {
        Button(action: HP.bind(selectTab(_:), .challenge)) {
            Text("Challenge")
        }
    }
    private var assetTabButton: some View {
        Button(action: HP.bind(selectTab(_:), .asset)) {
            Text("Asset")
        }
    }
    
    private func selectTab(_ tab: HPNavigation.Tab) {
        var n = bridge.data.navigation
        n.tab = tab
        bridge.queue(.navigation(n))
    }
    
    @ViewBuilder
    private func makeTabContent<Content: View>(id: HPNavigation.Tab, @ViewBuilder content: () -> Content) -> some View {
        
    }
}
