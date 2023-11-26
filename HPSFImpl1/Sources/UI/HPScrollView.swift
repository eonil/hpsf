import SwiftUI

public struct HPScrollView<Content: View>: View {
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

private extension HPScrollView {
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
        
        final class Impl: UIViewController {
            let scrollView = UIScrollView()
            let hostingController: UIHostingController<Content>
            init(content: Content) {
                hostingController = UIHostingController(rootView: content)
                super.init(nibName: nil, bundle: nil)
            }
            required init?(coder: NSCoder) {
                fatalError("Unsupported.")
            }
            override func viewDidLoad() {
                super.viewDidLoad()
                view.addSubview(scrollView)
                addChild(hostingController)
                view.addSubview(hostingController.view)
                hostingController.didMove(toParent: self)
            }
            override func viewDidLayoutSubviews() {
                super.viewDidLayoutSubviews()
                hostingController.view.frame = view.bounds
            }
        }
    }
}
