//import SwiftUI
//import UIKit
//
///// A view renders content only once and never gets updated again.
///// - This captures content at initialization and re-use them forever.
//public struct HPStaticContentView<Content: View>: View {
//    private var wrap: Wrap
//    private struct Wrap: View, Equatable {
//        var content: Content
//        static func == (_ a: Self, _ b: Self) -> Bool {
//            true
//        }
//        var body: some View {
//            content
//        }
//    }
//}
//
//public extension HPStaticContentView {
//    init(@ViewBuilder content: () -> Content) {
//        wrap = Wrap(content: content())
//    }
//    var body: some View {
//        EquatableView(content: wrap)
//    }
//}
//
////private extension HPStaticContentView {
////    struct Rep: UIViewControllerRepresentable {
////        func makeUIViewController(context: Context) -> some UIViewController {
////            
////        }
////        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
////            
////        }
////    }
////}
