public typealias HPVersion = Int64

public extension HPVersion {
    func revision() -> Self {
        self + 1
    }
}

@propertyWrapper
public struct HPVersioned<T> {
    private var content: T
    private var version = HPVersion.zero
    
    public init(wrappedValue: T) {
        content = wrappedValue
    }
    public var wrappedValue: T {
        get { content }
        set(x) {
            content = x
            version += 1
        }
    }
    public var projectedValue: Projection {
        get { Projection(version: version) }
    }
    public struct Projection {
        public var version: HPVersion
    }
}
