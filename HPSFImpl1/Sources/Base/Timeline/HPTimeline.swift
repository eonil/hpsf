public struct HPTableTimeline<Key, Value>: HPTimelineProtocol where Key: Comparable {
    public var transactions: BTList<Transaction>
    public struct Transaction: HPTimelineTransactionProtocol {
        public var operation: Operation
        public var point: Point
    }
    public struct Point: HPTimelinePointProtocol {
        public var timestamp: HPTimestamp
        public var version: HPVersion
        public var snapshot: HPTable<Key, Value>
    }
    public enum Operation: HPTimelineOperationProtocol {
        case reset
        case insert(BTSet<Key>)
        case update(BTSet<Key>)
        case remove(BTSet<Key>)
    }
    public init(initialSnapshot s: Snapshot) {
        let p = Point(timestamp: .min, version: .zero, snapshot: s)
        transactions = [Transaction(operation: .reset, point: p)]
    }
}

public struct HPListTimeline<Element>: HPTimelineProtocol {
    public var transactions: BTList<Transaction>
    public struct Transaction: HPTimelineTransactionProtocol {
        public var operation: Operation
        public var point: Point
    }
    public struct Point: HPTimelinePointProtocol {
        public var timestamp: HPTimestamp
        public var version: HPVersion
        public var snapshot: BTList<Element>
    }
    public enum Operation: HPTimelineOperationProtocol {
        case reset
        case insert(Range<Int>)
        case update(Range<Int>)
        case remove(Range<Int>)
    }
    public init(initialSnapshot s: Snapshot) {
        let p = Point(timestamp: .min, version: .zero, snapshot: s)
        transactions = [Transaction(operation: .reset, point: p)]
    }
}

@propertyWrapper
public struct HPTimelined<Base: HPCollectionTimelineSupport> where Base: RandomAccessCollection {
    var timeline: Base.Timeline
    public init(wrappedValue: Base) {
        timeline = Base.Timeline(initialSnapshot: wrappedValue)
    }
    public var wrappedValue: Base {
        get { timeline.transactions.last!.point.snapshot }
    }
    public var projectedValue: Base.TimelineEditor {
        get { Base.TimelineEditor(timeline: timeline) }
        set(x) {
            timeline = x.timeline
        }
    }
}
