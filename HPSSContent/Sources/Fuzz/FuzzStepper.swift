@HPCoreRun
struct FuzzStepper {
    var currencyCountRange: ClosedRange<Int>
    var pswapCountRange: ClosedRange<Int>
    var userWalletCountRange: ClosedRange<Int>
    var userPositionCountRange: ClosedRange<Int>
    var userPositionInExecutionCountRange: ClosedRange<Int>
    var changeCountRange: ClosedRange<Int>
    var intervalTimeRangeInMilliseconds: ClosedRange<Int>

    /// - 100-200 currencies.
    /// - 250-500 market instruments.
    /// - 100-200 holding positions.
    /// - 100-200 executing orders (positions).
    /// - 1-2 times update in a seconds.
    static func lowLoad() -> Self {
        FuzzStepper(
            currencyCountRange: 1000...2000,
            pswapCountRange: 1000...2000,
            userWalletCountRange: 2000...3000,
            userPositionCountRange: 4000...5000,
            userPositionInExecutionCountRange: 2000...3000,
            changeCountRange: 50...100,
            intervalTimeRangeInMilliseconds: 500...1000)
    }
    /// - 500-1000 currencies.
    /// - 500-1000 market instruments.
    /// - 250-500 holding positions.
    /// - 250-500 executing orders (positions).
    /// - 10-20 times update in a seconds.
    static func midLoad() -> Self {
        FuzzStepper(
            currencyCountRange: 1000...2000,
            pswapCountRange: 1000...2000,
            userWalletCountRange: 2000...3000,
            userPositionCountRange: 4000...5000,
            userPositionInExecutionCountRange: 2000...3000,
            changeCountRange: 50...100,
            intervalTimeRangeInMilliseconds: 50...100)
    }
    
    /// - 1000-2000 currencies.
    /// - 1000-2000 market instruments.
    /// - 2500-5000 holding positions.
    /// - 1500-3000 executing orders (positions).
    /// - 100-200 times update in a seconds.
    static func highLoad() -> Self {
        FuzzStepper(
            currencyCountRange: 1000...2000,
            pswapCountRange: 1000...2000,
            userWalletCountRange: 2000...3000,
            userPositionCountRange: 4000...5000,
            userPositionInExecutionCountRange: 2000...3000,
            changeCountRange: 50...100,
            intervalTimeRangeInMilliseconds: 5...10)
    }
    
    func step(repo: HPRepo) async -> HPRepo {
        var repo = repo
        repo.fuzzStepCurrencies(currencyCountRange, changeCountRange)
        repo.fuzzStepPSwaps(pswapCountRange, changeCountRange)
//        try? await Task.sleep(for: .milliseconds(.random(in: intervalTimeRangeInMilliseconds)))
        let ms = Int.random(in: intervalTimeRangeInMilliseconds)
        try? await Task.hpSleep(for: HPTimeInterval(ms) / 1000)
        return repo
    }
}


@HPCoreRun
private extension HPRepo {
    mutating func fuzzStepCurrencies(_ countRange: ClosedRange<Int>, _ changeCountRange: ClosedRange<Int>) {
        while market.currencyTable.count > countRange.lowerBound {
            let n = Int.random(in: changeCountRange)
            let n1 = max(n, market.currencyTable.count - countRange.lowerBound)
            for _ in 0..<n1 {
                if let symbol = market.currencyTable.randomElement()?.0 {
                    market.currencyTable[symbol] = nil
                }
            }
        }
        while market.currencyTable.count < countRange.upperBound {
            let n = Int.random(in: changeCountRange)
            let n1 = max(n, countRange.lowerBound - market.currencyTable.count)
            for _ in 0..<n1 {
                seed += 1
                let newSymbol = HPCurrencySymbol(code: "BTC\(seed)")
                market.currencyTable[newSymbol] = HPCurrencyDetail(
                    symbol: newSymbol,
                    humanReadableName: newSymbol.code,
                    usdPrice: .random(in: 0...1_000_000))
            }
        }
        for (symbol, var detail) in market.currencyTable {
            detail.usdPrice = .random(in: 0...1_000_000)
            market.currencyTable[symbol] = detail
        }
    }
    
    mutating func fuzzStepPSwaps(_ countRange: ClosedRange<Int>, _ changeCountRange: ClosedRange<Int>) {
        while market.pswapTable.count > countRange.lowerBound {
            let n = Int.random(in: changeCountRange)
            let n1 = max(n, market.pswapTable.count - countRange.lowerBound)
            for _ in 0..<n1 {
                if let symbol = market.pswapTable.randomElement()?.0 {
                    market.pswapTable[symbol] = nil
                }
            }
        }
        while market.pswapTable.count < countRange.upperBound {
            let n = Int.random(in: changeCountRange)
            let n1 = max(n, countRange.lowerBound - market.pswapTable.count)
            for _ in 0..<n1 {
                seed += 1
                let newSymbol = HPPSwapSymbol(code: "BTCUSDT\(seed).PERP")
                market.pswapTable[newSymbol] = HPPSwapDetail(
                    symbol: newSymbol,
                    humanReadableName: newSymbol.code,
                    midPrice: .random(in: 0...1_000_000),
                    markPrice: .random(in: 0...1_000_000),
                    lastPrice: .random(in: 0...1_000_000))
            }
        }
        for (symbol, var detail) in market.pswapTable {
            detail.midPrice = .random(in: 0...1_000_000)
            detail.markPrice = .random(in: 0...1_000_000)
            detail.lastPrice = .random(in: 0...1_000_000)
            market.pswapTable[symbol] = detail
        }
        market.pswapSymbolIndex = BTSet(market.pswapTable.keys)
    }
}

@HPCoreRun
private var seed = 0
