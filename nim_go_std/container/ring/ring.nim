type
  Ring* = ref object
    next, prev: Ring
    Value*: any

proc New*(n: int): Ring = discard
proc Len*(r: Ring): int = 0
proc Next*(r: Ring): Ring = r.next
proc Prev*(r: Ring): Ring = r.prev
proc Move*(r: Ring, n: int): Ring = discard
