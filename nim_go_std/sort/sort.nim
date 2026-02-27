import std/[algorithm, sequtils]
import ../slices/slices as goslices
import ../cmp/cmp as gocmp

type
  Interface* = concept x
    x.Len() is int
    x.Less(int, int) is bool
    x.Swap(int, int)

proc Sort*(data: Interface) =
  let n = data.Len()
  for i in 1 ..< n:
    var j = i
    while j > 0 and data.Less(j, j - 1):
      data.Swap(j, j - 1)
      j -= 1

proc Stable*(data: Interface) =
  let n = data.Len()
  for i in 1 ..< n:
    var j = i
    while j > 0 and data.Less(j, j - 1):
      data.Swap(j, j - 1)
      j -= 1

proc IsSorted*(data: Interface): bool =
  let n = data.Len()
  for i in 1 ..< n:
    if data.Less(i, i - 1): return false
  return true

proc Ints*(x: var seq[int]) = goslices.Sort(x)
proc Strings*(x: var seq[string]) = goslices.Sort(x)
proc Float64s*(x: var seq[float64]) = goslices.Sort(x)

proc IntsAreSorted*(x: seq[int]): bool = goslices.IsSorted(x)
proc StringsAreSorted*(x: seq[string]): bool = goslices.IsSorted(x)
proc Float64sAreSorted*(x: seq[float64]): bool = goslices.IsSorted(x)

proc Search*(n: int, f: proc(i: int): bool): int =
  var i = 0
  var j = n
  while i < j:
    let h = i + (j - i) div 2
    if not f(h): i = h + 1
    else: j = h
  return i

proc Find*(n: int, cmp: proc(i: int): int): (int, bool) =
  let i = Search(n, proc(i: int): bool = cmp(i) >= 0)
  if i < n and cmp(i) == 0: return (i, true)
  return (i, false)

proc SearchInts*(a: seq[int], x: int): int = Search(a.len, proc(i: int): bool = a[i] >= x)
proc SearchFloat64s*(a: seq[float64], x: float64): int = Search(a.len, proc(i: int): bool = a[i] >= x)
proc SearchStrings*(a: seq[string], x: string): int = Search(a.len, proc(i: int): bool = a[i] >= x)

proc Reverse*(data: Interface): Interface = data # Minimal
