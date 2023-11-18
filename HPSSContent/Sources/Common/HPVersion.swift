typealias HPVersion = Int64

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
