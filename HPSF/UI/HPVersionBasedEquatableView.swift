import SwiftUI

/// An `EquatableView`, but treats contents equal if provided versions are equal.
public struct HPVersionBasedEquatableView<Content: View>: View {
    private var determinant: DeterminantView
    private struct DeterminantView: View, Equatable {
        var version: HPVersion
        var content: () -> Content
        var body: some View {
            content()
        }
        static func == (_ a: Self, _ b: Self) -> Bool {
            a.version == b.version
        }
    }
}

public extension HPVersionBasedEquatableView {
    init(version: HPVersion, @ViewBuilder content: @escaping () -> Content) {
        determinant = DeterminantView(version: version, content: content)
    }
    var body: some View {
        EquatableView(content: determinant)
    }
}
