//import SwiftUI
//import UIKit
//
///// A vertical-stack view which grants view-graph update to segments that are visible within container & screen bounds.
/////
///// Design Decisions
///// -----------------
///// - Assumes layout of all segment content views are controlled only by input. (pure function)
///// - If content view size chages by unknown side-effects, it will be ignored from layout.
///// -
//struct HPVisibleOnlyUpdatedVStack<Segment: Hashable, Content: View>: View {
//    var spec: Spec
//    struct Spec {
//        var segments: [Segment]
//        var content: (Segment) -> Content
//    }
//    var body: some View {
//        
//    }
//}
//
//private extension HPVisibleOnlyUpdatedVStack {
//    struct Rep: UIViewControllerRepresentable {
//        func makeUIViewController(context: Context) -> Impl {
//            Impl()
//        }
//        func updateUIViewController(_ impl: Impl, context: Context) {
//        }
//        
//        final class Impl: UIViewController {
//            override func viewDidLayoutSubviews() {
//                super.viewDidLayoutSubviews()
//                let frameInContainer = view.frame
//                let frameInScreen = view.window
//                
//            }
//        }
//        
//        
//        private var isVisibleInScreen: Bool {
//            
//        }
//        
//        private var isVisibleInContainer: Bool {
//            
//        }
//    }
//}
