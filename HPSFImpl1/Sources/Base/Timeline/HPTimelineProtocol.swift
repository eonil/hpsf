public protocol HPTimelineProtocol {
    associatedtype Transaction: HPTimelineTransactionProtocol
    associatedtype Transactions: RandomAccessCollection<Transaction> & MutableCollection & RangeReplaceableCollection
    /// Collection of transactions.
    /// - First element should always be a transaction with `.reset` operation.
    /// - This collection cannbe be empty. Always have at least 1 element.
    var transactions: Transactions { get set }
    typealias Operation = Transaction.Operation
    typealias Point = Transaction.Point
    typealias Snapshot = Transaction.Point.Snapshot
    init(initialSnapshot: Snapshot)
    mutating func dropAll(before timestamp: HPTimestamp)
}

public extension HPTimelineProtocol {
    mutating func dropAll(before timestamp: HPTimestamp) {
        guard let x = transactions.first else { return }
        guard x.point.timestamp < timestamp else { return }
        var lastIndexToDrop = transactions.startIndex
        for i in transactions.indices {
            let x = transactions[i]
            if x.point.timestamp < timestamp {
                lastIndexToDrop = i
            }
            else {
                break
            }
        }
        transactions.removeSubrange(..<lastIndexToDrop)
    }
}

public protocol HPTimelineTransactionProtocol {
    /// Operation caused this change.
    var operation: Operation { get set }
    /// Result of the `operation`.
    var point: Point { get set }
    associatedtype Point: HPTimelinePointProtocol
    associatedtype Operation: HPTimelineOperationProtocol
}

public protocol HPTimelineOperationProtocol {
    static var reset: Self { get }
}

public protocol HPTimelinePointProtocol {
    var timestamp: HPTimestamp { get set }
    /// Version of snapshot.
    /// - Different snapshot should have different version.
    /// - Same snapshot is likely to have same version. If they have same version, we can skip expensive equality test.
    /// - This exists to help validation of point snapshot data.
    var version: HPVersion { get }
    var snapshot: Snapshot { get set }
    associatedtype Snapshot
}

public protocol HPTimelineEditorProtocol {
    init(timeline: Timeline)
    var timeline: Timeline { get set }
    associatedtype Timeline: HPTimelineProtocol
}
