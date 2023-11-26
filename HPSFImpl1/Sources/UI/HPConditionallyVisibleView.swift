import SwiftUI

public struct HPConditionallyVisibleView<Content: View>: View {
    private var spec: Spec
    private struct Spec {
        var condition: Bool
        var content: () -> Content
    }
}

public extension HPConditionallyVisibleView {
    init(condition: Bool, @ViewBuilder content: @escaping () -> Content) {
        spec = Spec(condition: condition, content: content)
    }
    var body: some View {
        spec.content().opacity(spec.condition ? 1 : 0)
    }
}
