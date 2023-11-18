import SwiftUI

struct HPText: View {
    var content: String
    init(_ content: String) {
        self.content = content
    }
    var body: some View {
        Text(verbatim: content)
    }
}
