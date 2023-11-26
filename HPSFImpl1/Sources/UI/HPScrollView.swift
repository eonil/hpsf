//import SwiftUI
//
//public struct HPScrollView<Content: View>: View {
//    private var content: () -> Content
//    public init(content: @escaping () -> Content) {
//        self.content = content
//    }
//    public var body: some View {
//        Rep(content: content)
//    }
//}
//
//private extension HPScrollView {
//    struct Rep: UIViewControllerRepresentable {
//        var content: () -> Content
//        func makeUIViewController(context: Context) -> Impl {
//            Impl(content: content())
//        }
//        func updateUIViewController(_ impl: Impl, context: Context) {
//            impl.scrollView.contentSize = contentSize
//            impl.hostingController.rootView = content()
//        }
//        
//        final class Impl: UIViewController, UIScrollViewDelegate {
//            let scrollView = ImplScrollView()
//            let hostingController: UIHostingController<Content>
//            init(content: Content) {
//                hostingController = UIHostingController(rootView: content)
//                super.init(nibName: nil, bundle: nil)
//                scrollView.delegate = self
//            }
//            required init?(coder: NSCoder) {
//                fatalError("Unsupported.")
//            }
//            override func viewDidLoad() {
//                super.viewDidLoad()
//                view.addSubview(scrollView)
//                addChild(hostingController)
//                view.addSubview(hostingController.view)
//                hostingController.didMove(toParent: self)
//            }
//            override func viewDidLayoutSubviews() {
//                super.viewDidLayoutSubviews()
//                hostingController.view.frame = view.bounds
//            }
//            
//            func scrollViewDidScroll(_: UIScrollView) {
//                scrollView.hp_broadcastScroll()
//            }
//        }
//    }
//    
//    final class ImplScrollView: UIScrollView, HPBroadcastingScrollHost {
//        private var delegateTable = [ObjectIdentifier: HPBroadcastingScrollHostDelegate]()
//        func hp_broadcastScroll() {
//            for delegate in delegateTable.values {
//                delegate.noteScroll()
//            }
//        }
//        func hp_addScrollDelegate(_ delegate: HPBroadcastingScrollHostDelegate) {
//            assert(delegateTable[delegate.id] == nil)
//            delegateTable[delegate.id] = delegate
//        }
//        func hp_removeScrollDelegate(_ delegate: HPBroadcastingScrollHostDelegate) {
//            assert(delegateTable[delegate.id] != nil)
//            delegateTable[delegate.id] = nil
//        }
//    }
//}
