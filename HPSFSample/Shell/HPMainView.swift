import SwiftUI
import HPSF

struct HPMainView: View {
    var bridge: HPBridge
    var body: some View {
        VStack {
            ZStack {
                HPConditionallyVisibleView(condition: bridge.data.navigation.selectedTab == .trade) {
                    HPTradeView(bridge: bridge).tag(HPNavigation.Tab.trade)
                }
                HPConditionallyVisibleView(condition: bridge.data.navigation.selectedTab == .challenge) {
                    HPChallengeView(bridge: bridge).tag(HPNavigation.Tab.challenge)
                }
                HPConditionallyVisibleView(condition: bridge.data.navigation.selectedTab == .asset) {
                    HPAssetView(bridge: bridge).tag(HPNavigation.Tab.asset)
                }
            }
            HStack {
                tradeTabButton
                challengeTabButton
                assetTabButton
            }
        }
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
        n.selectedTab = tab
        bridge.queue(.navigation(n))
    }
}
