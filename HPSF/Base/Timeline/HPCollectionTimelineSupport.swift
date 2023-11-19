public protocol HPCollectionTimelineSupport where Timeline.Snapshot == Self {
    associatedtype Timeline: HPTimelineProtocol
    associatedtype TimelineEditor: HPTimelineEditorProtocol where TimelineEditor.Timeline == Timeline
}
    
extension BTList: HPCollectionTimelineSupport {
}

public extension BTList {
    typealias Timeline = HPListTimeline<Element>
    struct TimelineEditor: HPTimelineEditorProtocol {
        public var timeline: Timeline
        public init(timeline: Timeline) {
            self.timeline = timeline
        }
        
        public mutating func reset(with elements: BTList, on timestamp: HPTimestamp) {
            precondition(timeline.transactions.last!.point.timestamp <= timestamp)
            let p = timeline.transactions.last!.point
            var s = p.snapshot
            s = elements
            timeline.transactions.append(Timeline.Transaction(
                operation: .reset,
                point: Timeline.Point(timestamp: timestamp, version: p.version.revision(), snapshot: s)))
        }
        public mutating func insert(contentsOf elements: BTList, at index: Index, on timestamp: HPTimestamp) {
            precondition(timeline.transactions.last!.point.timestamp <= timestamp)
            let p = timeline.transactions.last!.point
            var s = p.snapshot
            s.insert(contentsOf: elements, at: index)
            timeline.transactions.append(Timeline.Transaction(
                operation: .insert(index..<elements.count),
                point: Timeline.Point(timestamp: timestamp, version: p.version.revision(), snapshot: s)))
        }
        public mutating func removeSubrange(_ range: Range<Index>, on timestamp: HPTimestamp) {
            precondition(timeline.transactions.last!.point.timestamp <= timestamp)
            let p = timeline.transactions.last!.point
            var s = p.snapshot
            s.removeSubrange(range)
            timeline.transactions.append(Timeline.Transaction(
                operation: .remove(range),
                point: Timeline.Point(timestamp: timestamp, version: p.version.revision(), snapshot: s)))
        }
        public mutating func updateSubrange(_ range: Range<Index>, with elements: BTList, at timestamp: HPTimestamp) {
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
}

public extension HPTable {
    typealias Timeline = HPTableTimeline<Key, Value>
    struct TimelineEditor: HPTimelineEditorProtocol {
        public var timeline: Timeline
        public init(timeline: Timeline) {
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
