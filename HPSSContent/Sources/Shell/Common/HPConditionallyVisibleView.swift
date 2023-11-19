import SwiftUI

struct HPConditionallyVisibleView<Content: View>: View {
    init(condition: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.condition = condition
        self.content = content
    }
    var body: some View {
        content().opacity(condition ? 1 : 0)
    }
    
    private var condition: Bool
    private var content: () -> Content
}
