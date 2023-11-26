//import SwiftUI
//
///// A view suspends update of invisible segments.
/////
///// Design Choices
///// --------------
///// - Designed for small, fixed set of segments.
/////   - If you change segments configuration (`segments`), view-graph subtree will be recreated.
/////   - Changing height does not trigger view-graph recreation.
/////   -
/////
//struct HPLazyVStackView<Segment: Hashable, Content: View>: View {
//    private var spec: Spec
//    private struct Spec {
//        var segments: [Segment]
//        var heights: [CGFloat]
//        var content: (Segment) -> Content
//    }
//    
//    init(segments: [Segment], heights: [CGFloat], content: @escaping (Segment) -> Content) {
//        spec = Spec(segments: segments, heights: heights, content: content)
//    }
//    var body: some View {
//        
//    }
//}
