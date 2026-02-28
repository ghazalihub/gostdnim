import std/md5
import ../../hash/hash as gohash

proc New*(): gohash.Hash = nil # Simplified

proc Sum*(data: seq[byte]): array[16, byte] =
  let s = toMD5(cast[string](data))
  # MD5 type is array[16, uint8]
  return cast[array[16, byte]](s)
