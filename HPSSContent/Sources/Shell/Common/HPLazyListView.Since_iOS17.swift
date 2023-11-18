import SwiftUI

@available(iOS 17, *)
extension HPLazyListView {
    struct Since_iOS17: View {
        var spec: Spec
        var body: some View {
            ScrollView {
                GeometryReader { geometry in
                    if let y = geometry.bounds(of: .scrollView)?.minY {
                        Group {
                            let i = Int(y / 100)
                            ForEach(i..<(i+10), id: \.self) { i in
                                Color.red.frame(width: 100, height: 90, alignment: .topLeading)
                                    .offset(x: 0, y: CGFloat(i) * 100)
                            }
                        }
                    }
                }
                .frame(width: 300, height: 3000, alignment: .topLeading)
                .fixedSize()
            }
        }
    }
}
