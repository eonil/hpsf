import SwiftUI
#if canImport(UIKit)
import UIKit

extension HPLazyListView {
    /// Lazy-list implementation using `UIKit`.
    ///
    /// Known Issues
    /// - No *explicit identity* support. Only *structural ideneity* is supported.
    /// - **Do not assign an explicit identity.** It may cause worse rendering performance.
    @available(*, deprecated, message: "Use `UIKitMixed2`.")
    struct UIKitMixed1: View {
        var spec: Spec
        var body: some View {
            Rep(spec: spec)
        }

        struct Rep: UIViewControllerRepresentable {
            var spec: Spec
            func makeUIViewController(context: Context) -> Impl {
                Impl(spec: spec)
            }
            func updateUIViewController(_ controller: Impl, context: Context) {
                controller.spec = spec
            }
            
            final class Impl: UIViewController, UIScrollViewDelegate {
                var spec: Spec {
                    didSet {
                        placeCells()
                    }
                }
                let scrollView = UIScrollView()
                var itemHostingControllers = [UIHostingController<CellContent?>]()
                
                init(spec: Spec) {
                    self.spec = spec
                    super.init(nibName: nil, bundle: nil)
                    view.addSubview(scrollView)
                    scrollView.bounces = true
                    scrollView.alwaysBounceVertical = true
                    scrollView.delegate = self
                }
                @available(*, unavailable)
                required init?(coder: NSCoder) {
                    fatalError("Unsupported.")
                }
                override func viewDidLayoutSubviews() {
                    super.viewDidLayoutSubviews()
                    if scrollView.frame != view.bounds {
                        scrollView.frame = view.bounds
                        placeCells()
                    }
                }
                func scrollViewDidScroll(_ scrollView: UIScrollView) {
                    placeCells()
                }
                
                private func placeCells() {
                    let h = spec.cellHeight * CGFloat(spec.data.count)
                    let r = findVisibleCellIndices()
                    /// Refit to new cell count.
                    while itemHostingControllers.count < r.count {
                        let h = UIHostingController(rootView: nil as CellContent?)
                        addChild(h)
                        scrollView.addSubview(h.view)
                        h.didMove(toParent: self)
                        itemHostingControllers.append(h)
                    }
                    while itemHostingControllers.count > r.count {
                        let h = itemHostingControllers.last!
                        h.willMove(toParent: nil)
                        h.view.removeFromSuperview()
                        h.removeFromParent()
                        itemHostingControllers.removeLast()
                    }
                    
                    /// Layout.
                    if scrollView.contentSize.height != h {
                        let y = scrollView.contentOffset.y
                        scrollView.contentSize.height = h
                        scrollView.contentOffset.y = y
                    }
                    for (i,n) in findVisibleCellIndices().enumerated() {
                        let h = itemHostingControllers[i]
                        h.rootView = spec.cellContent(spec.data[n])
                        h.view.frame = CGRect(x: 0, y: CGFloat(n) * 50, width: 100, height: 50)
                    }
                }
                
                private func findVisibleCellIndices() -> Range<Int> {
                    let a = Int(floor(scrollView.contentOffset.y / spec.cellHeight))
                    let b = a + Int(ceil(scrollView.visibleSize.height / spec.cellHeight)) + 1
                    let a1 = max(a, 0)
                    let b1 = min(b, spec.data.count)
                    let b2 = max(a1, b1)
                    return a1..<b2
                }
            }
        }
    }
}
#endif
