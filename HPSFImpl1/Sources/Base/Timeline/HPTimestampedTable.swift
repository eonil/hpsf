//struct HPTimestampedTable<Key, Value> where Key: Comparable {
//    private var storage = HPTable<Key, HPTimestamped<Value>>()
//    
//    var count: Int {
//        storage.count
//    }
//    
//    mutating func insert(_ key:)
//    subscript(_ key: Key) -> Value? {
//        get { storage[key]?.wrappedValue }
//        set {
//            let oldValue = storage[key]
//            switch (oldValue, newValue) {
//            case (.none, .some(let b)): 
//                storage[key] = HPTimestamped(wrappedValue: b)
//            case (.some(var a), .some(let b)):
//                a.set(b, with: <#T##HPTimestamp#>)
//                a.projectedValue = b
//                storage[key] = a
//            case (.some(let a), .none):
//                storage[key] = nil
//            case (.none, .none):
//            }
//            if var p = storage[key] {
//            }
//            else {
//                storage[key] = HPTimestamped(wrappedValue: x)
//            }
//        }
//    }
//    
//    typealias Element = (key: Key, value: Value)
//    func makeIterator() -> some IteratorProtocol<Element> {
//        IteratorWrap(base: storage.makeIterator())
//    }
//    private struct IteratorWrap: IteratorProtocol {
//        var base: Storage.Iterator
//        mutating func next() -> Element? {
//            guard let e = base.next() else { return nil }
//            return (e.0, e.1)
//        }
//    }
//    
//    var keys: some Sequence<Key> {
//        storage.keys
//    }
//    var values: some Sequence<Value> {
//        storage.values
//    }
//}
