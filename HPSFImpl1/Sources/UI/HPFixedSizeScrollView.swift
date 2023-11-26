import SwiftUI

public struct HPFixedSizeScrollView<Content: View>: View {
    private var contentSize: CGSize
    private var contentView: () -> Content
    public init(contentSize: CGSize, contentView: @escaping () -> Content) {
        self.contentSize = contentSize
        self.contentView = contentView
    }
    public var body: some View {
        Rep(contentSize: contentSize, contentView: contentView)
    }
}

private extension HPFixedSizeScrollView {
    struct Rep: UIViewControllerRepresentable {
        var contentSize: CGSize
        var contentView: () -> Content
        func makeUIViewController(context: Context) -> Impl {
            Impl(content: contentView())
        }
        func updateUIViewController(_ impl: Impl, context: Context) {
            impl.scrollView.contentSize = contentSize
            impl.hostingController.rootView = contentView()
        }
        
        final class Impl: UIViewController, UIScrollViewDelegate {
            let scrollView = ImplScrollView()
            let hostingController: UIHostingController<Content>
            init(content: Content) {
                hostingController = UIHostingController(rootView: content)
                super.init(nibName: nil, bundle: nil)
                scrollView.delegate = self
            }
            required init?(coder: NSCoder) {
                fatalError("Unsupported.")
            }
            override func viewDidLoad() {
                super.viewDidLoad()
                view.addSubview(scrollView)
                addChild(hostingController)
                scrollView.addSubview(hostingController.view)
                hostingController.didMove(toParent: self)
            }
            override func viewDidLayoutSubviews() {
                super.viewDidLayoutSubviews()
                scrollView.frame = view.bounds
                hostingController.view.frame.size = scrollView.contentSize
            }
            
            func scrollViewDidScroll(_: UIScrollView) {
                scrollView.hp_broadcastScroll()
            }
        }
        
        final class ImplScrollView: UIScrollView, HPBroadcastingScrollHost {
            private var delegateTable = [ObjectIdentifier: HPBroadcastingScrollHostDelegate]()
            func hp_broadcastScroll() {
                for delegate in delegateTable.values {
                    delegate.noteScroll()
                }
            }
            var hp_contentOffset: CGPoint {
                contentOffset
            }
            var hp_visibleSize: CGSize {
                visibleSize
            }
            func hp_addScrollDelegate(_ delegate: HPBroadcastingScrollHostDelegate) {
                assert(delegateTable[delegate.id] == nil)
                delegateTable[delegate.id] = delegate
            }
            func hp_removeScrollDelegate(_ delegate: HPBroadcastingScrollHostDelegate) {
                assert(delegateTable[delegate.id] != nil)
                delegateTable[delegate.id] = nil
            }
        }
    }
}
