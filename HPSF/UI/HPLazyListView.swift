import SwiftUI

/// A lazily rendered list view.
/// - Fixed cell height.
/// - Item view content is derived from source item element.
/// - Source item element is `Hashable`. This view does not redraw items for same source element.
///   - Provide different key to redraw view.
///
public struct HPLazyListView<Source, ItemView: View>: View where Source: RandomAccessCollection, Source.Index == Int, Source.Element: Hashable {
    var spec: Spec
    struct Spec {
        var data: Source
        var cellHeight: CGFloat
        var itemContent: (Source.Element) -> ItemView
    }
}

public extension HPLazyListView {
    init(data: Source, cellHeight: CGFloat, @ViewBuilder itemContent: @escaping (Source.Element) -> ItemView) {
        spec = Spec(data: data, cellHeight: cellHeight, itemContent: itemContent)
    }
    var body: some View {
        UIKitMixed(spec: spec)
//        if #available(iOS 17, *) {
//            PureSwiftUI(spec: spec)
//        }
//        else {
//            UIKitMixed(spec: spec)
//        }
    }
}
