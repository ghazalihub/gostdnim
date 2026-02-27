import std/tables

proc Equal*[K, V](m1, m2: Table[K, V]): bool =
  if m1.len != m2.len: return false
  for k, v1 in m1:
    if k notin m2: return false
    if m2[k] != v1: return false
  return true

proc EqualFunc*[K, V1, V2](m1: Table[K, V1], m2: Table[K, V2], eq: proc(a: V1, b: V2): bool): bool =
  if m1.len != m2.len: return false
  for k, v1 in m1:
    if k notin m2: return false
    if not eq(v1, m2[k]): return false
  return true

proc Clone*[K, V](m: Table[K, V]): Table[K, V] =
  var res = initTable[K, V]()
  for k, v in m: res[k] = v
  return res

proc Copy*[K, V](dst: var Table[K, V], src: Table[K, V]) =
  for k, v in src: dst[k] = v

proc DeleteFunc*[K, V](m: var Table[K, V], del: proc(k: K, v: V): bool) =
  var toDelete: seq[K]
  for k, v in m:
    if del(k, v): toDelete.add(k)
  for k in toDelete: m.del(k)

proc Keys*[K, V](m: Table[K, V]): seq[K] =
  for k in m.keys: result.add(k)

proc Values*[K, V](m: Table[K, V]): seq[V] =
  for v in m.values: result.add(v)

proc Clear*[K, V](m: var Table[K, V]) = m.clear()
