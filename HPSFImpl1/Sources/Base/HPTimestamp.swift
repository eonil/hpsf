import Darwin

public struct HPTimestamp: Hashable, Comparable {
    var unixEpochInNanoseconds: UInt64
}

public extension HPTimestamp {
    static func < (_ a: Self, _ b: Self) -> Bool {
        a.unixEpochInNanoseconds < b.unixEpochInNanoseconds
    }
    
    static func now() -> Self {
        Self(unixEpochInNanoseconds: clock_gettime_nsec_np(CLOCK_REALTIME))
    }
    static var min: Self {
        Self(unixEpochInNanoseconds: .min)
    }
    static var max: Self {
        Self(unixEpochInNanoseconds: .max)
    }
}

@propertyWrapper
public struct HPTimestamped<T> {
    var content: T
    var timestamp: HPTimestamp
    
    public init(wrappedValue: T) {
        content = wrappedValue
        timestamp = .min
    }
    public var wrappedValue: T {
        get { content }
    }
    public mutating func set(_ content: T, with timestamp: HPTimestamp) {
        self.content = content
        self.timestamp = timestamp
    }
    
    public var projectedValue: Projection {
        get { Projection(timestamp: timestamp) }
    }
    public struct Projection {
        public var timestamp: HPTimestamp
    }
}

