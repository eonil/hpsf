/// A wrapper type around `BTMap`.
/// - `BTMap` is feature-complete, but does not conform some Swift standard collection conventions.
/// - This wrapper provides such compatibility.
public struct HPTable<Key, Value>: Sequence where Key: Comparable {
    private var storage = Storage()
    private typealias Storage = BTMap<Key, Value>
}

public extension HPTable {
    var count: Int {
        storage.count
    }
    
    subscript(_ key: Key) -> Value? {
        get { storage[key] }
        set(x) { storage[key] = x }
    }
    
    typealias Element = (key: Key, value: Value)
    func makeIterator() -> some IteratorProtocol<Element> {
        IteratorWrap(base: storage.makeIterator())
    }
    private struct IteratorWrap: IteratorProtocol {
        var base: Storage.Iterator
        mutating func next() -> Element? {
            guard let e = base.next() else { return nil }
            return (e.0, e.1)
        }
    }
    
    var keys: some Sequence<Key> {
        storage.keys
    }
    var values: some Sequence<Value> {
        storage.values
    }
}

//extension HPTable {
//        var asRandomAccessCollection: RandomAccessWrap {
//    
//        }
//    struct RandomAccessWrap: RandomAccessCollection {
//        typealias Element = HPTable.Element
//        typealias SubSequence = Self
////        typealias Indices = <#type#>
//        
//            var base: HPTable
//            var startIndex: some Comparable { base.storage.startIndex }
//            var endIndex: some Comparable { base.storage.endIndex }
//            func index(after i: Index) -> some Comparable { base.storage.index(after: i) }
//            func index(before i: Index) -> some Comparable { base.storage.index(before: i) }
//            func index(_ i: Index, offsetBy distance: Int) -> some Comparable { base.storage.index(i, offsetBy: distance) }
//            func distance(from start: Index, to end: Index) -> Int { base.storage.distance(from: start, to: end) }
//            subscript(position: Index) -> Element { base.storage[position] }
//        }
//}

public extension HPTable {
    /// Returns a random-access wrapper using integer index.
    /// - Index-based operation costs are all `O(log n)`.
    /// - This conversion is `O(1)` and zero-cost.
    var asIntIndexedRandomAccessCollection: IntIndexedRandomAccessWrap {
        IntIndexedRandomAccessWrap(base: self)
    }
    struct IntIndexedRandomAccessWrap: RandomAccessCollection {
        var base: HPTable
    }
}

public extension HPTable.IntIndexedRandomAccessWrap {
    typealias Index = Int
    typealias Element = HPTable.Element
    var startIndex: Index { 0 }
    var endIndex: Index { base.count }
    subscript(position: Index) -> Element { base.storage.element(atOffset: position) }
}
