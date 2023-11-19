import SwiftUI
import UIKit

extension HPLazyListView {
    struct Pre_iOS17: View {
        var spec: Spec
        var body: some View {
            Rep(spec: spec)
        }
        
        struct Rep: UIViewRepresentable {
            var spec: Spec
            func makeUIView(context: Context) -> CV {
                CV(spec: spec)
            }
            func updateUIView(_ view: CV, context: Context) {
                view.spec = spec
            }
            
            final class CV: UIView, UIScrollViewDelegate {
                var spec: Spec {
                    didSet {
                        placeCells()
                    }
                }
                let scrollView = UIScrollView()
                var itemHostingControllers = [UIHostingController<ItemView?>]()
                
                init(spec: Spec) {
                    self.spec = spec
                    super.init(frame: .zero)
                }
                @available(*, unavailable)
                required init?(coder: NSCoder) {
                    fatalError("Unsupported.")
                }
                
                override func didMoveToWindow() {
                    super.didMoveToWindow()
                    if scrollView.superview == nil {
                        addSubview(scrollView)
                        scrollView.bounces = true
                        scrollView.alwaysBounceVertical = true
                        scrollView.delegate = self
                    }
                }
                override func layoutSubviews() {
                    super.layoutSubviews()
                    if scrollView.frame != bounds {
                        scrollView.frame = bounds
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
                        let h = UIHostingController(rootView: nil as ItemView?)
                        scrollView.addSubview(h.view)
                        itemHostingControllers.append(h)
                    }
                    while itemHostingControllers.count > r.count {
                        let h = itemHostingControllers.last!
                        h.view.removeFromSuperview()
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
                        h.rootView = spec.itemContent(spec.data[n])
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



