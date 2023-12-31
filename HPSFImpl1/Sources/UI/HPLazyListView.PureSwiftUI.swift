import SwiftUI

@available(iOS 17, *)
extension HPLazyListView {
    struct PureSwiftUI: View {
        var spec: Spec
        var body: some View {
            ZStack {
                Color.clear
                ScrollView {
                    let totalHeight = spec.cellHeight * CGFloat(spec.data.count)
                    let _ = print(totalHeight)
                    GeometryReader { geometry in
                        if let scrollBounds = geometry.bounds(of: .scrollView) {
                            let range = findVisibleCellIndices(in: scrollBounds)
                            ForEach(range, id: \.self) { i in
                                let item = spec.data[i]
                                let cell = spec.cellContent(item)
                                cell.frame(width: 100, height: spec.cellHeight, alignment: .topLeading)
                                    .offset(x: 0, y: CGFloat(i) * spec.cellHeight)
                            }
                        }
                    }
                    .frame(width: 300, height: 30000, alignment: .topLeading)
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        
        private func findVisibleCellIndices(in scrollBounds: CGRect) -> Range<Int> {
            let a = Int(floor(scrollBounds.minY / spec.cellHeight))
            let b = a + Int(ceil(scrollBounds.height / spec.cellHeight)) + 1
            let a1 = max(a, 0)
            let b1 = min(b, spec.data.count)
            let b2 = max(a1, b1)
            return a1..<b2
        }
    }
}
