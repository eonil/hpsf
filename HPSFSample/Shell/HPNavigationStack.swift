import SwiftUI
import UIKit

/// WIP...
struct HPNavigationStack<Page: Hashable, PageContent: View>: View {
    private var spec: Spec
    fileprivate struct Spec {
        @Binding var pageStack: [Page]
        var pageContent: (Page) -> PageContent
    }
    
    init(pageStack: Binding<[Page]>, @ViewBuilder pageContent: @escaping (Page) -> PageContent) {
        spec = Spec(pageStack: pageStack, pageContent: pageContent)
    }
    var body: some View {
        Rep(spec: spec)
    }
}

private extension HPNavigationStack {
    struct Rep: UIViewControllerRepresentable {
        var spec: Spec
        func makeUIViewController(context: Context) -> Impl {
            Impl(spec: spec)
        }
        func updateUIViewController(_ controller: Impl, context: Context) {
            controller.queueSpec(spec)
        }
        
        /// - Programmatic control takes priority.
        /// - If caller queues `spec` in the middle of user interactions,
        final class Impl: UINavigationController, UINavigationControllerDelegate {
            init(spec: Spec) {
                placedSpec = Spec(pageStack: .constant([]), pageContent: spec.pageContent)
                super.init(nibName: nil, bundle: nil)
                setup()
                placePages(by: spec)
            }
            required init?(coder aDecoder: NSCoder) {
                fatalError("Unsupported.")
            }
            func queueSpec(_ spec: Spec) {
                specQueue.append(spec)
                stepPages()
            }
            
            func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
                pagesInShowing.insert(ObjectIdentifier(viewController))
            }
            func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
                pagesInShowing.remove(ObjectIdentifier(viewController))
                stepPages()
            }
            
            private func setup() {
                self.delegate = self
            }
            
            private var specQueue = [Spec]()
            private var placedSpec: Spec
            private var pagesInShowing =  Set<ObjectIdentifier>()
            private var pageViewControllers = [PageViewController]()
            private typealias PageViewController = UIHostingController<PageContent>
            
            private func stepPages() {
                guard pagesInShowing.isEmpty else { return }
                view.isUserInteractionEnabled = specQueue.isEmpty
                guard !specQueue.isEmpty else { return }
                let spec = specQueue.removeFirst()
                placePages(by: spec)
            }
            
            private func placePages(by spec: Spec) {
                var newPageVCs = pageViewControllers
                let c = min(newPageVCs.count, spec.pageStack.count)
                for i in 0..<c {
                    newPageVCs[i].rootView = spec.pageContent(spec.pageStack[i])
                }
                while newPageVCs.count < spec.pageStack.count {
                    let i = newPageVCs.count
                    let p = spec.pageContent(spec.pageStack[i])
                    newPageVCs.append(PageViewController(rootView: p))
                }
                while newPageVCs.count > spec.pageStack.count {
                    newPageVCs.removeLast()
                }
                setViewControllers(newPageVCs, animated: true)
                placedSpec = spec
            }
//            private func scanSpec() -> [Page] {
//                
//            }
        }
    }
}
