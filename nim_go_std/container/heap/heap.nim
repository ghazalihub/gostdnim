import ../sort/sort as gosort

type
  Interface* = concept x
    x is gosort.Interface
    x.Push(auto)
    x.Pop() is auto

proc up(h: Interface, j0: int) =
  var j = j0
  while true:
    let i = (j - 1) div 2 # parent
    if i == j or not h.Less(j, i):
      break
    h.Swap(i, j)
    j = i

proc down(h: Interface, i0, n: int): bool =
  var i = i0
  while true:
    let j1 = 2 * i + 1
    if j1 >= n or j1 < 0: # j1 < 0 after int overflow
      break
    var j = j1 # left child
    let j2 = j1 + 1
    if j2 < n and h.Less(j2, j1):
      j = j2 # right child
    if not h.Less(j, i):
      break
    h.Swap(i, j)
    i = j
  return i > i0

proc Init*(h: Interface) =
  let n = h.Len()
  for i in countdown(n div 2 - 1, 0):
    discard down(h, i, n)

proc Push*(h: Interface, x: any) =
  h.Push(x)
  up(h, h.Len() - 1)

proc Pop*(h: Interface): any =
  let n = h.Len() - 1
  h.Swap(0, n)
  discard down(h, 0, n)
  return h.Pop()

proc Remove*(h: Interface, i: int): any =
  let n = h.Len() - 1
  if n != i:
    h.Swap(i, n)
    if not down(h, i, n):
      up(h, i)
  return h.Pop()

proc Fix*(h: Interface, i: int) =
  if not down(h, i, h.Len()):
    up(h, i)
