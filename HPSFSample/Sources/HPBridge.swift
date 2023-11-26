import HPSFImpl1

struct HPBridge {
    var queue = HP.noop as (HPAction) -> Void
    var data = HPRendition()
}

