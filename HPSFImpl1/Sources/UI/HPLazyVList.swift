import SwiftUI
import UIKit

/// A lazily rendered list view.
/// - Fixed cell height.
/// - Item view content is derived from source item element.
/// - Source item element is `Hashable`. This view does not redraw items for same source element.
///   - Provide different key to redraw view.
///
/// - Note:
///     Due to implementation details, this must be contained in a `HPScrollView` or `HPFixedSizeScrollView`.
///     This won't work properly if contained in any other kind of scroll-view implementation.
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

private extension HPLazyVList {
    struct Rep: UIViewControllerRepresentable {
        var spec: Spec
        func makeUIViewController(context: Context) -> Impl {
            Impl(spec: spec)
        }
        func updateUIViewController(_ controller: Impl, context: Context) {
            controller.spec = spec
        }
        
        final class Impl: UIViewController {
            init(spec: Spec) {
                self.spec = spec
                super.init(nibName: nil, bundle: nil)
                railView.onScroll = { [weak self] in self?.placeCells() }
                railView.spec = spec
                railView.invalidateIntrinsicContentSize()
                view.setNeedsLayout()
            }
            @available(*, unavailable)
            required init?(coder: NSCoder) {
                fatalError("Unsupported.")
            }
            var spec: Spec {
                didSet {
                    railView.spec = spec
                    railView.invalidateIntrinsicContentSize()
                    placeCells()
                }
            }
            
            var railView: RailView {
                view as! RailView
            }
            override func loadView() {
                view = RailView(spec: spec)
            }
            override func viewDidLayoutSubviews() {
                super.viewDidLayoutSubviews()
                if railView.frame != view.bounds {
                    railView.frame = view.bounds
                    placeCells()
                }
            }
            
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
                        railView.addSubview(cellVC.view)
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
                guard let scrollHost = HPBroadcastingScroll.findNearestOverSuperviewTree(in: view.superview) else { return 0..<0 }
                let a = Int(floor(scrollHost.hp_contentOffset.y / spec.cellHeight))
                let b = a + Int(ceil(scrollHost.hp_visibleSize.height / spec.cellHeight)) + 1
//                let a = Int(floor(railView.bounds.minY / spec.cellHeight))
//                let b = Int(ceil(railView.bounds.maxY / spec.cellHeight)) + 1
                let a1 = max(a, 0)
                let b1 = min(b, spec.data.count)
                let b2 = max(a1, b1)
                return a1..<b2
            }
            
//            private func boundsOfVisiblePartOnScreen() -> CGRect {
//                guard let window = view.window else { return .zero }
//                let frameInWindow =  window.convert(window.screen.bounds, from: nil)
//                screen.bounds
//            }
        }
    }
    
    final class RailView: UIView {
        var spec: Spec
        var onScroll = HP.noop
        init(spec: Spec) {
            self.spec = spec
            super.init(frame: .zero)
        }
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("Unsupported.")
        }
        override var intrinsicContentSize: CGSize {
            return CGSize(
                width: UIView.noIntrinsicMetric,
                height: spec.cellHeight * CGFloat(spec.data.count))
        }
        
        override func willMove(toSuperview newSuperview: UIView?) {
            super.willMove(toSuperview: newSuperview)
            uninstall()
        }
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            install()
        }
        deinit {
            uninstall()
        }
        
        private func install() {
            let scrollHost = HPBroadcastingScroll.findNearestOverSuperviewTree(in: superview)
            scrollHost?.hp_addScrollDelegate(HPBroadcastingScrollHostDelegate(
                id: ObjectIdentifier(self),
                noteScroll: onScroll))
        }
        private func uninstall() {
            let scrollHost = HPBroadcastingScroll.findNearestOverSuperviewTree(in: superview)
            scrollHost?.hp_removeScrollDelegate(HPBroadcastingScrollHostDelegate(
                id: ObjectIdentifier(self),
                noteScroll: HP.noop))
        }
    }
    
}

