enum HPCommand {
    case boot
    case subscribePSwap(HPPSwapSymbol)
    case unsubscribePSwap
    case login
    case logout
}
