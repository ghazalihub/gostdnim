import std/[algorithm, sequtils]
import ../cmp/cmp as gocmp

proc Equal*[E](s1, s2: seq[E]): bool =
  if s1.len != s2.len: return false
  for i in 0 ..< s1.len:
    if s1[i] != s2[i]: return false
  return true

proc EqualFunc*[E1, E2](s1: seq[E1], s2: seq[E2], eq: proc(a: E1, b: E2): bool): bool =
  if s1.len != s2.len: return false
  for i in 0 ..< s1.len:
    if not eq(s1[i], s2[i]): return false
  return true

proc Compare*[E: gocmp.Ordered](s1, s2: seq[E]): int =
  let n = min(s1.len, s2.len)
  for i in 0 ..< n:
    let c = gocmp.Compare(s1[i], s2[i])
    if c != 0: return c
  if s1.len < s2.len: return -1
  if s1.len > s2.len: return 1
  return 0

proc CompareFunc*[E1, E2](s1: seq[E1], s2: seq[E2], cmp: proc(a: E1, b: E2): int): int =
  let n = min(s1.len, s2.len)
  for i in 0 ..< n:
    let c = cmp(s1[i], s2[i])
    if c != 0: return c
  if s1.len < s2.len: return -1
  if s1.len > s2.len: return 1
  return 0

proc Index*[E](s: seq[E], v: E): int =
  for i in 0 ..< s.len:
    if s[i] == v: return i
  return -1

proc IndexFunc*[E](s: seq[E], f: proc(e: E): bool): int =
  for i in 0 ..< s.len:
    if f(s[i]): return i
  return -1

proc Contains*[E](s: seq[E], v: E): bool = Index(s, v) >= 0
proc ContainsFunc*[E](s: seq[E], f: proc(e: E): bool): bool = IndexFunc(s, f) >= 0

proc Insert*[E](s: seq[E], i: int, v: varargs[E]): seq[E] =
  var res = s
  res.insert(@v, i)
  return res

proc Delete*[E](s: seq[E], i, j: int): seq[E] =
  var res = s
  if i < j: res.delete(i, j - 1)
  return res

proc DeleteFunc*[E](s: seq[E], del: proc(e: E): bool): seq[E] =
  var res = s
  res.keepIf(proc(x: E): bool = not del(x))
  return res

proc Replace*[E](s: seq[E], i, j: int, v: varargs[E]): seq[E] =
  var res = s
  if i < j: res.delete(i, j - 1)
  res.insert(@v, i)
  return res

proc Clone*[E](s: seq[E]): seq[E] =
  if s.len == 0: return @[]
  return s

proc Compact*[E](s: seq[E]): seq[E] =
  if s.len == 0: return s
  var res: seq[E]
  res.add(s[0])
  for i in 1 ..< s.len:
    if s[i] != s[i-1]: res.add(s[i])
  return res

proc Grow*[E](s: seq[E], n: int): seq[E] = s
proc Clip*[E](s: seq[E]): seq[E] = s
proc Reverse*[E](s: var seq[E]) = s.reverse()

proc Concat*[E](slices: varargs[seq[E]]): seq[E] =
  var res: seq[E]
  for s in slices: res.add(s)
  return res

proc Repeat*[E](x: seq[E], count: int): seq[E] =
  var res: seq[E]
  for i in 0 ..< count: res.add(x)
  return res

proc Sort*[E: gocmp.Ordered](x: var seq[E]) =
  x.sort(proc(a, b: E): int = gocmp.Compare(a, b))

proc SortFunc*[E](x: var seq[E], cmp: proc(a, b: E): int) = x.sort(cmp)

proc SortStableFunc*[E](x: var seq[E], cmp: proc(a, b: E): int) = x.sort(cmp) # Simplified

proc IsSorted*[E: gocmp.Ordered](x: seq[E]): bool =
  for i in 1 ..< x.len:
    if gocmp.Less(x[i], x[i-1]): return false
  return true

proc IsSortedFunc*[E](x: seq[E], cmp: proc(a, b: E): int): bool =
  for i in 1 ..< x.len:
    if cmp(x[i], x[i-1]) < 0: return false
  return true

proc Min*[E: gocmp.Ordered](x: seq[E]): E =
  if x.len == 0: raise newException(ValueError, "empty slice")
  var m = x[0]
  for i in 1 ..< x.len:
    if gocmp.Less(x[i], m): m = x[i]
  return m

proc Max*[E: gocmp.Ordered](x: seq[E]): E =
  if x.len == 0: raise newException(ValueError, "empty slice")
  var m = x[0]
  for i in 1 ..< x.len:
    if gocmp.Less(m, x[i]): m = x[i]
  return m

proc BinarySearch*[E: gocmp.Ordered](x: seq[E], target: E): (int, bool) =
  let idx = x.lowerBound(target, proc(a, b: E): int = gocmp.Compare(a, b))
  if idx < x.len and x[idx] == target: return (idx, true)
  return (idx, false)

proc BinarySearchFunc*[E, T](x: seq[E], target: T, cmp: proc(e: E, t: T): int): (int, bool) =
  let idx = x.lowerBound(target, cmp)
  if idx < x.len and cmp(x[idx], target) == 0: return (idx, true)
  return (idx, false)
