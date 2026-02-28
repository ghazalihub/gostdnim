import malebolgia
import std/macros

var mpool = createMaster()

macro go*(call: untyped): untyped =
  result = quote do:
    mpool.spawn `call`

proc WaitGoroutines*() =
  mpool.awaitAll:
    discard
