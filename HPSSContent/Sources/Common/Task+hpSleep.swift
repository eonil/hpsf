extension Task where Success == Never, Failure == Never {
    static func hpSleep(for seconds: HPTimeInterval) async throws {
        try await sleep(nanoseconds: UInt64(HPTimeInterval(1_000_000_000) * seconds))
    }
}
