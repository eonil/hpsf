import SwiftUI

/// A paged scroll-view.
///
/// - This is a specialized view for very specific use-case.
///   - Do not try to use this for incompatible use cases.
/// - Treats `pages` as ID for each page.
///   - If page ID is same, view-subtree will remain.
///   - If page ID is different, new view-subtree will be created.
/// - Intended to be used with dozens of pages.
///   - Not designed for massive amount of pages.
///
public struct HPPagedScrollView<Page: Hashable, Content: View>: View {
    var spec: Spec
    struct Spec {
        var pages: [Page]
        var content: (Page) -> Content
    }
}

public extension HPPagedScrollView {
    init(pages: [Page], content: @escaping (Page) -> Content) {
        spec = Spec(pages: pages, content: content)
    }
    var body: some View {
        Rep(spec: spec)
    }
}

private extension HPPagedScrollView {
    struct Rep: UIViewControllerRepresentable {
        var spec: Spec
        func makeUIViewController(context: Context) -> Impl {
            Impl(spec: spec)
        }
        func updateUIViewController(_ impl: Impl, context: Context) {
            impl.spec = spec
        }
        
        final class Impl: UIViewController {
            private let scrollView = UIScrollView()
            private var pageHostingControllerMap = [Page: PageHostingController]()
            private typealias PageHostingController = UIHostingController<Content>
            
            var spec: Spec {
                didSet {
                    placeCells()
                }
            }
            init(spec: Spec) {
                self.spec = spec
                super.init(nibName: nil, bundle: nil)
            }
            required init?(coder: NSCoder) {
                fatalError("Unsupported.")
            }
            override func viewDidLoad() {
                super.viewDidLoad()
                view.addSubview(scrollView)
                placeCells()
            }
            override func viewDidLayoutSubviews() {
                super.viewDidLayoutSubviews()
                positionCells()
            }
            
            private func placeCells() {
                let oldPages = Set(pageHostingControllerMap.keys)
                let newPages = Set(spec.pages)
                guard oldPages != newPages else { return }
                /// Now something should be changed.
                let insertedPaged = newPages.subtracting(oldPages)
                let removedPages = oldPages.subtracting(newPages)
                for page in removedPages {
                    assert(pageHostingControllerMap[page] != nil)
                    guard let pageVC = pageHostingControllerMap[page] else { continue }
                    pageVC.willMove(toParent: nil)
                    pageVC.view.removeFromSuperview()
                    pageVC.removeFromParent()
                    pageHostingControllerMap[page] = nil
                }
                for page in insertedPaged {
                    assert(pageHostingControllerMap[page] == nil)
                    let pageContent = spec.content(page)
                    let pageVC = PageHostingController(rootView: pageContent)
                    addChild(pageVC)
                    scrollView.addSubview(pageVC.view)
                    pageVC.didMove(toParent: self)
                    pageHostingControllerMap[page] = pageVC
                }
                view.setNeedsLayout()
            }
            
            private func positionCells() {
                let containerBounds = view.bounds
                for (i, page) in spec.pages.enumerated() {
                    assert(pageHostingControllerMap[page] != nil)
                    guard let pageVC = pageHostingControllerMap[page] else { continue }
                    let x = CGFloat(i) * containerBounds.width
                    let targetFrame = containerBounds.offsetBy(dx: x, dy: 0)
                    pageVC.view.frame = targetFrame
                }
            }
        }
    }
}
