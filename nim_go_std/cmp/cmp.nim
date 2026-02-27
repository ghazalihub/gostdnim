type
  Ordered* = concept x, y
    (x < y) is bool

proc isNaN[T: Ordered](x: T): bool =
  when T is float or T is float32 or T is float64:
    x != x
  else:
    false

proc Less*[T: Ordered](x, y: T): bool =
  (isNaN(x) and not isNaN(y)) or x < y

proc Compare*[T: Ordered](x, y: T): int =
  let xNaN = isNaN(x)
  let yNaN = isNaN(y)
  if xNaN:
    if yNaN: return 0
    return -1
  if yNaN:
    return 1
  if x < y:
    return -1
  if x > y:
    return 1
  return 0

proc Or*[T](vals: varargs[T]): T =
  var zero: T
  for val in vals:
    if val != zero:
      return val
  return zero
