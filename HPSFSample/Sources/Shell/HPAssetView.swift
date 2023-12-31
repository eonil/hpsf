import SwiftUI

struct HPAssetView: View {
    var bridge: HPBridge
    var body: some View {
        HPAssetContentView(bridge: bridge)
    }
}

struct HPAssetContentView: View {
    var bridge: HPBridge
    var body: some View {
        VStack {
            Text("Currencies: \(bridge.data.repo.market.currencyTable.count)")
            Text("P-Swaps: \(bridge.data.repo.market.pswapTable.count)")
            Text("Wallets: \(bridge.data.repo.user.walletTable.count)")
            Text("Positions: \(bridge.data.repo.user.positionTable.count)")
            HPAssetBalaceView(bridge: bridge)
        }
    }
}

#Preview {
    HPAssetContentView(bridge: HPBridge())
}
