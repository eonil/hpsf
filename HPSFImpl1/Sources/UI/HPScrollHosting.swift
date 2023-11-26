import UIKit

enum HPBroadcastingScroll {
    static func findNearestOverSuperviewTree(in view: UIView?) -> HPBroadcastingScrollHost? {
        guard let view = view else { return nil }
        if let host = view as? HPBroadcastingScrollHost { return host }
        return findNearestOverSuperviewTree(in: view.superview)
    }
}

protocol HPBroadcastingScrollHost {
    var hp_contentOffset: CGPoint { get }
    var hp_visibleSize: CGSize { get }
    func hp_addScrollDelegate(_ delegate: HPBroadcastingScrollHostDelegate)
    func hp_removeScrollDelegate(_ delegate: HPBroadcastingScrollHostDelegate)
}

struct HPBroadcastingScrollHostDelegate {
    var id: ObjectIdentifier
    var noteScroll: () -> Void
}
