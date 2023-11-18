struct HPBridge {
    var queue = noop as (HPCommand) -> Void
    var data = HPRepo()
}

