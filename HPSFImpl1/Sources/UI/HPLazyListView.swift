import SwiftUI

/// A lazily rendered list view.
/// - Fixed cell height.
/// - Item view content is derived from source item element.
/// - Source item element is `Hashable`. This view does not redraw items for same source element.
///   - Provide different key to redraw view.
/// - Cell-views
///
public struct HPLazyListView<Source, CellContent: View>: View where Source: RandomAccessCollection, Source.Index == Int, Source.Element: Hashable {
    var spec: Spec
    struct Spec {
        var data: Source
        var cellHeight: CGFloat
        var cellContent: (Source.Element) -> CellContent
    }
}

public extension HPLazyListView {
    init(data: Source, cellHeight: CGFloat, @ViewBuilder cellContent: @escaping (Source.Element) -> CellContent) {
        spec = Spec(data: data, cellHeight: cellHeight, cellContent: cellContent)
    }
    var body: some View {
        UIKitMixed2(spec: spec)
//        if #available(iOS 17, *) {
//            PureSwiftUI(spec: spec)
//        }
//        else {
//            UIKitMixed(spec: spec)
//        }
    }
}
