import std/atomics

proc LoadInt32*(addr_val: ptr int32): int32 =
  load(cast[ptr Atomic[int32]](addr_val)[], moRelaxed)

proc StoreInt32*(addr_val: ptr int32, val: int32) =
  store(cast[ptr Atomic[int32]](addr_val)[], val, moRelaxed)

proc AddInt32*(addr_val: ptr int32, delta: int32): int32 =
  fetchAdd(cast[ptr Atomic[int32]](addr_val)[], delta, moRelaxed) + delta

proc CompareAndSwapInt32*(addr_val: ptr int32, old, new_val: int32): bool =
  var expected = old
  compareExchange(cast[ptr Atomic[int32]](addr_val)[], expected, new_val, moRelaxed, moRelaxed)

proc LoadInt64*(addr_val: ptr int64): int64 =
  load(cast[ptr Atomic[int64]](addr_val)[], moRelaxed)

proc StoreInt64*(addr_val: ptr int64, val: int64) =
  store(cast[ptr Atomic[int64]](addr_val)[], val, moRelaxed)

proc AddInt64*(addr_val: ptr int64, delta: int64): int64 =
  fetchAdd(cast[ptr Atomic[int64]](addr_val)[], delta, moRelaxed) + delta

proc CompareAndSwapInt64*(addr_val: ptr int64, old, new_val: int64): bool =
  var expected = old
  compareExchange(cast[ptr Atomic[int64]](addr_val)[], expected, new_val, moRelaxed, moRelaxed)

proc LoadUint32*(addr_val: ptr uint32): uint32 =
  load(cast[ptr Atomic[uint32]](addr_val)[], moRelaxed)

proc StoreUint32*(addr_val: ptr uint32, val: uint32) =
  store(cast[ptr Atomic[uint32]](addr_val)[], val, moRelaxed)

proc AddUint32*(addr_val: ptr uint32, delta: uint32): uint32 =
  fetchAdd(cast[ptr Atomic[uint32]](addr_val)[], delta, moRelaxed) + delta

proc CompareAndSwapUint32*(addr_val: ptr uint32, old, new_val: uint32): bool =
  var expected = old
  compareExchange(cast[ptr Atomic[uint32]](addr_val)[], expected, new_val, moRelaxed, moRelaxed)

proc LoadUint64*(addr_val: ptr uint64): uint64 =
  load(cast[ptr Atomic[uint64]](addr_val)[], moRelaxed)

proc StoreUint64*(addr_val: ptr uint64, val: uint64) =
  store(cast[ptr Atomic[uint64]](addr_val)[], val, moRelaxed)

proc AddUint64*(addr_val: ptr uint64, delta: uint64): uint64 =
  fetchAdd(cast[ptr Atomic[uint64]](addr_val)[], delta, moRelaxed) + delta

proc CompareAndSwapUint64*(addr_val: ptr uint64, old, new_val: uint64): bool =
  var expected = old
  compareExchange(cast[ptr Atomic[uint64]](addr_val)[], expected, new_val, moRelaxed, moRelaxed)
