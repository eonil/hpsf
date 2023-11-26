import SwiftUI

/// Creates a borderline between SwiftUI view supertree and subtrees by inserting a UIKit view-controller.
/// Not sure this would be useful or not. We are going to find out...
public struct HPBorderlineView<Content: View>: View {
    private var content: () -> Content
    public init(content: @escaping () -> Content) {
        self.content = content
    }
    public var body: some View {
        Rep(content: content)
    }
}

private extension HPBorderlineView {
    struct Rep: UIViewControllerRepresentable {
        var content: () -> Content
        init(content: @escaping () -> Content) {
            self.content = content
        }
        func makeUIViewController(context: Context) -> Impl {
            Impl(content: content())
        }
        func updateUIViewController(_ impl: Impl, context: Context) {
            impl.hostingController.rootView = content()
        }
        
        final class Impl: UIViewController {
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
