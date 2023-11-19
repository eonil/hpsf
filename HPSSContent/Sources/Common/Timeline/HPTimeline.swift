struct HPTableTimeline<Key, Value>: HPTimelineProtocol where Key: Comparable {
    var transactions: BTList<Transaction>
    struct Transaction: HPTimelineTransactionProtocol {
        var operation: Operation
        var point: Point
    }
    struct Point: HPTimelinePointProtocol {
        var timestamp: HPTimestamp
        var version: HPVersion
        var snapshot: HPTable<Key, Value>
    }
    enum Operation: HPTimelineOperationProtocol {
        case reset
        case insert(BTSet<Key>)
        case update(BTSet<Key>)
        case remove(BTSet<Key>)
    }
    init(initialSnapshot s: Snapshot) {
        let p = Point(timestamp: .min, version: .zero, snapshot: s)
        transactions = [Transaction(operation: .reset, point: p)]
    }
}

struct HPListTimeline<Element>: HPTimelineProtocol {
    var transactions: BTList<Transaction>
    struct Transaction: HPTimelineTransactionProtocol {
        var operation: Operation
        var point: Point
    }
    struct Point: HPTimelinePointProtocol {
        var timestamp: HPTimestamp
        var version: HPVersion
        var snapshot: BTList<Element>
    }
    enum Operation: HPTimelineOperationProtocol {
        case reset
        case insert(Range<Int>)
        case update(Range<Int>)
        case remove(Range<Int>)
    }
    init(initialSnapshot s: Snapshot) {
        let p = Point(timestamp: .min, version: .zero, snapshot: s)
        transactions = [Transaction(operation: .reset, point: p)]
    }
}

@propertyWrapper
struct HPTimelined<Base: HPCollectionTimelineSupport> where Base: RandomAccessCollection {
    var timeline: Base.Timeline
    init(wrappedValue: Base) {
        timeline = Base.Timeline(initialSnapshot: wrappedValue)
    }
    var wrappedValue: Base {
        get { timeline.transactions.last!.point.snapshot }
    }
    var projectedValue: Base.TimelineEditor {
        get { Base.TimelineEditor(timeline: timeline) }
        set(x) {
            timeline = x.timeline
        }
    }
}

protocol HPCollectionTimelineSupport where Timeline.Snapshot == Self {
    associatedtype Timeline: HPTimelineProtocol
    associatedtype TimelineEditor: HPTimelineEditorProtocol where TimelineEditor.Timeline == Timeline
}
    
extension BTList: HPCollectionTimelineSupport {
    typealias Timeline = HPListTimeline<Element>
    struct TimelineEditor: HPTimelineEditorProtocol {
        var timeline: Timeline
        init(timeline: Timeline) {
            self.timeline = timeline
        }
        
        mutating func reset(with elements: BTList, on timestamp: HPTimestamp) {
            precondition(timeline.transactions.last!.point.timestamp <= timestamp)
            let p = timeline.transactions.last!.point
            var s = p.snapshot
            s = elements
            timeline.transactions.append(Timeline.Transaction(
                operation: .reset,
                point: Timeline.Point(timestamp: timestamp, version: p.version.revision(), snapshot: s)))
        }
        mutating func insert(contentsOf elements: BTList, at index: Index, on timestamp: HPTimestamp) {
            precondition(timeline.transactions.last!.point.timestamp <= timestamp)
            let p = timeline.transactions.last!.point
            var s = p.snapshot
            s.insert(contentsOf: elements, at: index)
            timeline.transactions.append(Timeline.Transaction(
                operation: .insert(index..<elements.count),
                point: Timeline.Point(timestamp: timestamp, version: p.version.revision(), snapshot: s)))
        }
        mutating func removeSubrange(_ range: Range<Index>, on timestamp: HPTimestamp) {
            precondition(timeline.transactions.last!.point.timestamp <= timestamp)
            let p = timeline.transactions.last!.point
            var s = p.snapshot
            s.removeSubrange(range)
            timeline.transactions.append(Timeline.Transaction(
                operation: .remove(range),
                point: Timeline.Point(timestamp: timestamp, version: p.version.revision(), snapshot: s)))
        }
        mutating func updateSubrange(_ range: Range<Index>, with elements: BTList, at timestamp: HPTimestamp) {
            precondition(timeline.transactions.last!.point.timestamp <= timestamp)
            precondition(range.count == elements.count)
            let p = timeline.transactions.last!.point
            var s = p.snapshot
            s.replaceSubrange(range, with: elements)
            timeline.transactions.append(Timeline.Transaction(
                operation: .update(range),
                point: Timeline.Point(timestamp: timestamp, version: p.version.revision(), snapshot: s)))
        }
    }
}

extension HPTable: HPCollectionTimelineSupport {
    typealias Timeline = HPTableTimeline<Key, Value>
    struct TimelineEditor: HPTimelineEditorProtocol {
        var timeline: Timeline
        init(timeline: Timeline) {
            self.timeline = timeline
        }
        mutating func insert(_ value: Value, for key: Key, on timestamp: HPTimestamp) {
            precondition(timeline.transactions.last!.point.timestamp <= timestamp)
            let p = timeline.transactions.last!.point
            var s = p.snapshot
            s[key] = value
            timeline.transactions.append(Timeline.Transaction(
                operation: .insert([key]),
                point: Timeline.Point(timestamp: timestamp, version: p.version.revision(), snapshot: s)))
        }
        mutating func remove(_ value: Value, for key: Key, on timestamp: HPTimestamp) {
            precondition(timeline.transactions.last!.point.timestamp <= timestamp)
            let p = timeline.transactions.last!.point
            var s = p.snapshot
            s[key] = nil
            timeline.transactions.append(Timeline.Transaction(
                operation: .remove([key]),
                point: Timeline.Point(timestamp: timestamp, version: p.version.revision(), snapshot: s)))
        }
    }
}
