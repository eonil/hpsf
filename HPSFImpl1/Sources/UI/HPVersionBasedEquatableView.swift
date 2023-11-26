import SwiftUI

/// An `EquatableView`, but treats contents equal if provided versions are equal.
public struct HPVersionBasedEquatableView<Version: Equatable, Content: View>: View {
    private var determinant: Determinant
    private struct Determinant: View, Equatable {
        var version: Version
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
    init(version: Version, @ViewBuilder content: @escaping () -> Content) {
        determinant = Determinant(version: version, content: content)
    }
    var body: some View {
        EquatableView(content: determinant)
    }
}
