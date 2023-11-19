import SwiftUI

/// A view trigger rendering only if condition is satisfied.
/// - Once rendered view-graph won't disappear even if condition is not satisfied,
/// - Unsatisfied condition simply means rendered view-graph won't be changed at all until condition to be satisfied.
public struct HPConditionallyUpdatedView<Content: View>: View {
    private var wrappedView: WrappedView
    private struct WrappedView: Equatable, View {
        var condition: Bool
        var content: () -> Content
        static func == (_: Self, _ b: Self) -> Bool {
            !b.condition
        }
        var body: some View {
            content()
        }
    }
}

public extension HPConditionallyUpdatedView {
    init(condition: Bool, @ViewBuilder content: @escaping () -> Content) {
        wrappedView = WrappedView(condition: condition, content: content)
    }
    var body: some View {
        EquatableView(content: wrappedView)
    }
}
