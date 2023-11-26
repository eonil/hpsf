import SwiftUI

/// A lazily rendered list view.
/// - Fixed cell height.
/// - Item view content is derived from source item element.
/// - Source item element is `Hashable`. This view does not redraw items for same source element.
///   - Provide different key to redraw view.
/// - Cell-views
///
public struct HPLazyVList<Source, CellContent: View>: View where Source: RandomAccessCollection, Source.Index == Int, Source.Element: Hashable {
    var spec: Spec
    struct Spec {
        var data: Source
        var cellHeight: CGFloat
        var cellContent: (Source.Element) -> CellContent
    }
}

public extension HPLazyVList {
    init(data: Source, cellHeight: CGFloat, @ViewBuilder cellContent: @escaping (Source.Element) -> CellContent) {
        spec = Spec(data: data, cellHeight: cellHeight, cellContent: cellContent)
    }
    var body: some View {
        Rep(spec: spec)
    }
}


import SwiftUI
#if canImport(UIKit)
import UIKit

extension HPLazyVList {
    struct Rep: UIViewControllerRepresentable {
        var spec: Spec
        func makeUIViewController(context: Context) -> Impl {
            Impl(spec: spec)
        }
        func updateUIViewController(_ controller: Impl, context: Context) {
            controller.spec = spec
        }
        
        final class Impl: UIViewController, UIScrollViewDelegate {
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
            var spec: Spec {
                didSet {
                    placeCells()
                }
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
            
            let scrollView = UIScrollView()
            var visibleItemHostingControllerTable = [Source.Element: UIHostingController<CellContent>]()
            private func placeCells() {
                let h = spec.cellHeight * CGFloat(spec.data.count)
                let r = findVisibleCellIndices()
                let oldTable = visibleItemHostingControllerTable
                var newTable = [Source.Element: UIHostingController<CellContent>]()
                for i in r {
                    let item = spec.data[i]
                    if let cellVC = visibleItemHostingControllerTable[item] {
                        assert(cellVC.parent != nil)
                        newTable[item] = cellVC
                        cellVC.rootView = spec.cellContent(item)
                    }
                    else {
                        let cellVC = UIHostingController(rootView: spec.cellContent(item))
                        addChild(cellVC)
                        scrollView.addSubview(cellVC.view)
                        cellVC.didMove(toParent: self)
                        newTable[item] = cellVC
                    }
                }
                for (item, cellVC) in oldTable {
                    if newTable[item] == nil {
                        cellVC.willMove(toParent: nil)
                        cellVC.view.removeFromSuperview()
                        cellVC.removeFromParent()
                    }
                }

                /// Layout.
                if scrollView.contentSize.height != h {
                    let y = scrollView.contentOffset.y
                    scrollView.contentSize.height = h
                    scrollView.contentOffset.y = y
                }
                for i in r {
                    let item = spec.data[i]
                    assert(newTable[item] != nil)
                    if let cellVC = newTable[item] {
                        cellVC.view.frame = CGRect(x: 0, y: CGFloat(i) * 50, width: 100, height: 50)
                    }
                }
                
                visibleItemHostingControllerTable = newTable
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
#endif
