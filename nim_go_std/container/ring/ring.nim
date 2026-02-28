type
  Ring*[T] = ref object
    next, prev: Ring[T]
    Value*: T

proc init[T](r: Ring[T]): Ring[T] =
  r.next = r
  r.prev = r
  return r

proc Next*[T](r: Ring[T]): Ring[T] =
  if r.next == nil: return r.init()
  return r.next

proc Prev*[T](r: Ring[T]): Ring[T] =
  if r.next == nil: return r.init()
  return r.prev

proc Move*[T](r: Ring[T], n: int): Ring[T] =
  if r.next == nil: discard r.init()
  var tr = r
  var tn = n
  if tn < 0:
    while tn < 0:
      tr = tr.prev
      tn += 1
  elif tn > 0:
    while tn > 0:
      tr = tr.next
      tn -= 1
  return tr

proc New*[T](n: int): Ring[T] =
  if n <= 0: return nil
  var r = Ring[T]()
  var p = r
  for i in 1 ..< n:
    p.next = Ring[T](prev: p)
    p = p.next
  p.next = r
  r.prev = p
  return r

proc Link*[T](r: Ring[T], s: Ring[T]): Ring[T] =
  let n = r.Next()
  if s != nil:
    let p = s.Prev()
    r.next = s
    s.prev = r
    n.prev = p
    p.next = n
  return n

proc Unlink*[T](r: Ring[T], n: int): Ring[T] =
  if n <= 0: return nil
  return r.Link(r.Move(n + 1))

proc Len*[T](r: Ring[T]): int =
  var n = 0
  if r != nil:
    n = 1
    var p = r.Next()
    while p != r:
      n += 1
      p = p.next
  return n

proc Do*[T](r: Ring[T], f: proc(a: T)) =
  if r != nil:
    f(r.Value)
    var p = r.Next()
    while p != r:
      f(p.Value)
      p = p.next
