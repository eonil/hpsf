import Foundation
import BTree

public typealias BTList<T> = List<T>
public typealias BTMap<K,V> = Map<K,V> where K: Comparable
public typealias BTSet<T> = SortedSet<T> where T: Comparable

public typealias HPTimeInterval = TimeInterval
