struct HPRepo {
    @HPVersioned var market = Market()
    struct Market {
        @HPVersioned var currencyTable = BTMap<HPCurrencySymbol, HPCurrencyDetail>()
        @HPVersioned var pswapTable = BTMap<HPPSwapSymbol, HPPSwapDetail>()
        @HPVersioned var pswapSymbolIndex = BTSet<HPPSwapSymbol>()
    }
    
    @HPVersioned var user = User()
    struct User {
        @HPVersioned var walletTable = BTMap<HPCurrencySymbol, HPDecimal>()
        @HPVersioned var positionTable = BTMap<HPPSwapSymbol, HPDecimal>()
    }
}
