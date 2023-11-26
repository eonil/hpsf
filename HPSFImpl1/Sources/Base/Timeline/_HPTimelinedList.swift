///// A random-access collection based on "timeline" datastructure.
///// - If timeline is empty, this cannot be defined. But we treat it as an empty state.
//struct HPTimelinedList<T>: RandomAccessCollection {
//    /// This can't be empty.
//    private(set) var timeline: Timeline
//    typealias Timeline = HPCollectionTimeline<Snapshot>
//    typealias Index = Int
//    init() {
//        let v = HPVersion()
//        let p = Timeline.Point(version: v, range: 0..<0, snapshot: Snapshot())
//        let tx = Timeline.Transaction(old: p, new: p)
//        timeline = Timeline(transactions: [tx])
//    }
//    private var lastSnapshot: Snapshot { timeline.transactions.last!.new.snapshot }
//    var startIndex: Int { lastSnapshot.startIndex }
//    var endIndex: Int { lastSnapshot.endIndex }
//    
//    private var storage = Snapshot()
//    typealias Snapshot = BTList<T>
//}
//
//
//
///// Describes state changes over time for a random-access collection.
///// - Sometimes, collection readers need how it's been changed to perform certain operations.
///// - This is usually needed to maximize cache utilization by tracking changes.
///// - Stores series of changes and snapshots.
/////   - Starts with first snapshot and ends with last snapshot.
/////   - Transactions describe change between snapshot.
/////   - Therefore, this always will store one more snapshot than transactions.
///// - This is just an attached data to a "timelined-list". This doesn't work independently.
//struct HPCollectionTimeline<Snapshot: RandomAccessCollection> {
//    var transactions: BTList<Transaction>
//    struct Transaction {
//        var old: Point
//        var new: Point
//    }
//    struct Point {
//        var version: HPVersion
//        var range: Range<Snapshot.Index>
//        var snapshot: Snapshot
//    }
//}
////extension HPCollectionTimeline where Snapshot: RangeReplaceableCollection {
////    init() {
////        let emptySnapshot = Snapshot()
////        let emptyPoint = Point(range: emptySnapshot.startIndex..<emptySnapshot.endIndex, snapshot: emptySnapshot)
////        self = Self(transactions: [Transaction(old: emptyPoint, new: emptyPoint)])
////    }
////}
////
