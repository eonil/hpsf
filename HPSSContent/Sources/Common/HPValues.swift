import Foundation

typealias HPDecimal = Int64

typealias HPCurrencySymbol = HPSymbol

struct HPCurrencyDetail {
    var symbol: HPCurrencySymbol
    var humanReadableName: String
    var usdPrice: HPDecimal
}

typealias HPPSwapSymbol = HPSymbol

struct HPPSwapDetail {
    var symbol: HPPSwapSymbol
    var humanReadableName: String
    
    var midPrice: HPDecimal
    var markPrice: HPDecimal
    var lastPrice: HPDecimal
}

struct HPSymbol: Hashable, Comparable {
    var code: String
    static var usdt: Self { Self(code: "USDT") }
    static var btc: Self { Self(code: "BTC") }
    static var xrp: Self { Self(code: "XRP") }
    
    static func < (_ a: Self, _ b: Self) -> Bool {
        a.code < b.code
    }
}
