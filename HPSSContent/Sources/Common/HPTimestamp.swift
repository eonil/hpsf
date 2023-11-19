import Darwin

struct HPTimestamp: Hashable, Comparable {
    var unixEpochInNanoseconds: UInt64
    static func < (_ a: Self, _ b: Self) -> Bool {
        a.unixEpochInNanoseconds < b.unixEpochInNanoseconds
    }
}

extension HPTimestamp {
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
struct HPTimestamped<T> {
    var content: T
    var timestamp: HPTimestamp
    
    init(wrappedValue: T) {
        content = wrappedValue
        timestamp = .min
    }
    var wrappedValue: T {
        get { content }
    }
    mutating func set(_ content: T, with timestamp: HPTimestamp) {
        self.content = content
        self.timestamp = timestamp
    }
    
    var projectedValue: Projection {
        get { Projection(timestamp: timestamp) }
    }
    struct Projection {
        var timestamp: HPTimestamp
    }
}
