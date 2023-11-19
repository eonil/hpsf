extension HP {
    static func bind<T>(_ function: @escaping (T) -> Void, _ value: T) -> (() -> Void) {
        return { function(value) }
    }
}
