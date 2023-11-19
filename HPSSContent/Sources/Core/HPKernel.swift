@HPCoreRun
struct HPKernel: ~Copyable {
    static var shared = HPKernel()
    private var repo = HPRepo()
    private let fuzz = FuzzStepper.midLoad()
    
    private init() {}
    mutating func run() async {
        /// As a sample, update values 10 times in a second.
    STEP:
        do {
            repo = await fuzz.step(repo: repo)
            continue STEP
        }
    }
    
    mutating func apply(_ command: HPCommand) {
        switch command {
        case .boot: break
        default: break
        }
    }
    
    func wait() async {
        try? await Task.hpSleep(for: 0.1)
//        try? await Task.sleep(for: .milliseconds(100))
    }
    func snapshot() -> HPRepo {
        // TODO: Wait for semaphore and return updated repo.
        repo
    }
}
