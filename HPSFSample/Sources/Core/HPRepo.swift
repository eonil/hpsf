import HPSFImpl1

struct HPRepo {
    @HPVersioned var market = Market()
    struct Market {
        @HPVersioned var currencyTable = HPTable<HPCurrencySymbol, HPCurrencyDetail>()
        @HPVersioned var pswapTable = HPTable<HPPSwapSymbol, HPPSwapDetail>()
        
    }
    
    @HPVersioned var user = User()
    struct User {
        @HPVersioned var walletTable = HPTable<HPCurrencySymbol, HPDecimal>()
        @HPVersioned var positionTable = HPTable<HPPSwapSymbol, HPDecimal>()
    }

    /// Pre-calculated & cached values that are expensive to recalculate.
    /// - This must be fully synchronized with others.
    var memo = Memo()
    struct Memo {
        @HPTimelined var marketPSwapSymbolDisplayOrder = BTList<HPPSwapSymbol>()
    }
}
