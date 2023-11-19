typealias HPVersion = Int64

extension HPVersion {
    func revision() -> Self {
        self + 1
    }
}

@propertyWrapper
struct HPVersioned<T> {
    private var content: T
    private var version = HPVersion.zero
    
    init(wrappedValue: T) {
        content = wrappedValue
    }
    var wrappedValue: T {
        get { content }
        set(x) {
            content = x
            version += 1
        }
    }
    var projectedValue: Projection {
        get { Projection(version: version) }
    }
    struct Projection {
        var version: HPVersion
    }
}
