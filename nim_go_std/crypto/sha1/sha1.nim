import std/sha1 as nimsha1
import ../../hash/hash as gohash

proc New*(): gohash.Hash = nil # Simplified

proc Sum*(data: seq[byte]): array[20, byte] =
  let h = nimsha1.compute(cast[string](data))
  return cast[array[20, byte]](h)
