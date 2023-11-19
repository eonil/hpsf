import HPSF

struct HPRepo {
    @HPVersioned var market = Market()
    struct Market {
        @HPVersioned var currencyTable = BTMap<HPCurrencySymbol, HPCurrencyDetail>()
        @HPVersioned var pswapTable = BTMap<HPPSwapSymbol, HPPSwapDetail>()
        
    }
    
    @HPVersioned var user = User()
    struct User {
        @HPVersioned var walletTable = BTMap<HPCurrencySymbol, HPDecimal>()
        @HPVersioned var positionTable = BTMap<HPPSwapSymbol, HPDecimal>()
    }

    /// Pre-calculated & cached values that are expensive to recalculate.
    /// - This must be fully synchronized with others.
    var memo = Memo()
    struct Memo {
        @HPTimelined var marketPSwapSymbolDisplayOrder = BTList<HPPSwapSymbol>()
    }
}
