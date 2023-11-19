///// A table structure with timeline records.
//struct HPTimelinedTable<Key, Value> where Key: Comparable {
//    private(set) var timeline = Timeline()
//    
//    init() {
//        let v = HPVersion()
//        let s = Snapshot()
//        let p = Timeline.Point(version: v, snapshot: s)
//        timeline.transactions.append(Timeline.Transaction(oldPoint: p, operation: .reset, newPoint: p))
//    }
//
//    private var lastSnapshot: Snapshot {
//        timeline.transactions.last!.newPoint.snapshot
//    }
//    subscript(_ key: Key) -> Value? {
//        get {
//            lastSnapshot[key]
//        }
//        set(x) {
//            var s = lastSnapshot
//            if let x = x {
//                if s[key] == nil {
//                    let op = Timeline.Operation.insert([k])
//                }
//                s[key] = x
//            }
//            else {
//                if s[key] == nil { return } /// No-op.
//                s[key]
//            }
//        }
//    }
//    
//}
//
//extension HPTimelinedTable {
//    struct Timeline {
//        var transactions = BTList<Transaction>()
//        
//        struct Transaction {
//            var oldPoint: Point
//            var operation: Operation
//            var newPoint: Point
//        }
//        
//        enum Operation {
//            case reset
//            case insert(BTSet<Key>)
//            case update(BTSet<Key>)
//            case remove(BTSet<Key>)
//        }
//        
//        struct Point {
//            var version: HPVersion
//            var snapshot: Snapshot
//        }
//    }
//    
//    typealias Snapshot = HPTable<Key, Value>
//}
