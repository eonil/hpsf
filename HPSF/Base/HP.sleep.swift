public extension HP {
    static func sleep(for seconds: HPTimeInterval) async throws {
        try await Task.sleep(nanoseconds: UInt64(HPTimeInterval(1_000_000_000) * seconds))
    }
}

