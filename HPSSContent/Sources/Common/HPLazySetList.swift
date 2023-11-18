struct HPLazySetList<T: Comparable>: RandomAccessCollection {
    var base: BTSet<T>
    var startIndex: Int { 0 }
    var endIndex: Int { base.count }
    subscript(position: Int) -> T {
        base[position]
    }
}
