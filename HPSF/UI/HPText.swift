import SwiftUI

/// Always fixed size text.
/// - Text size measuring is very expensive operation.
/// - If your layout is depending on text size measuring, it can't be performant.
/// - This view prevents you to depend on such layout by using fixed size.
public struct HPText: View {
    private var content: String
    private var width: CGFloat
    private var height: CGFloat
}

public extension HPText {
    init(_ content: String, width: CGFloat, height: CGFloat) {
        self.content = content
        self.width = width
        self.height = height
    }
    var body: some View {
        Text(verbatim: content)
            .frame(width: width, height: height, alignment: .center)
            .fixedSize()
    }
}
