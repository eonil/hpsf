import SwiftUI
import HPSFImpl1

struct HPTradeOrderFormView: View {
    var bridge: HPBridge
    var body: some View {
        HPConditionallyUpdatedView(condition: bridge.data.navigation.tradeTab.isOrderForm) {
            let _ = print("render: \(#fileID)")
            Text(#fileID)
        }
    }
}
