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
                let v = CV()
                v.spec = spec
                return v
            }
            func updateUIView(_ uiView: CV, context: Context) {
                uiView.spec = spec
            }
            
            final class CV: UIView, UIScrollViewDelegate {
                var spec: Spec? {
                    didSet {
                        placeCells()
                    }
                }
                let scrollView = UIScrollView()
                var itemHostingControllers = [UIHostingController<ItemView>]()
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
                    let h = if let spec = spec { spec.cellHeight * CGFloat(spec.data.count) } else { 0 } as CGFloat
                    if scrollView.contentSize.height != h {
                        let y = scrollView.contentOffset.y
                        scrollView.contentSize.height = h
                        scrollView.contentOffset.y = y
                    }
                    for h in itemHostingControllers {
                        h.view.removeFromSuperview()
                    }
                    itemHostingControllers.removeAll()
                    if let spec = spec {
                        for i in findVisibleCellIndices() {
                            let h = UIHostingController(rootView: spec.itemContent(spec.data[i]))
                            h.view.frame = CGRect(x: 0, y: CGFloat(i) * 50, width: 100, height: 50)
                            h.view.backgroundColor = .blue
                            scrollView.addSubview(h.view)
                            itemHostingControllers.append(h)
                        }
                    }
                }
                
                private func findVisibleCellIndices() -> Range<Int> {
                    guard let spec = spec else { return 0..<0 }
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



