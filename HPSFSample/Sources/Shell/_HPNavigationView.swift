//import SwiftUI
//
//struct HPNavigationView<Content: View>: View {
//    var content: () -> Content
//    init(@ViewBuilder content: @escaping () -> Content) {
//        self.content = content
//    }
//    var body: some View {
//        if #available(iOS 17, *) {
//            NavigationStack(root: content)
//        }
//        else {
//            NavigationView(content: content)
//        }
//    }
//}
