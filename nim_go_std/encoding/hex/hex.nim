import std/strutils
import ../../strconv/strconv as gostrconv

proc EncodedLen*(n: int): int = n * 2
proc DecodedLen*(x: int): int = x div 2

proc Encode*(dst, src: var seq[byte]): int =
  let s = toHex(cast[string](src)).toLowerAscii
  for i, c in s:
    if i < dst.len: dst[i] = byte(c)
  return s.len

proc EncodeToString*(src: seq[byte]): string = toHex(cast[string](src)).toLowerAscii

proc Decode*(dst: var seq[byte], src: seq[byte]): (int, gostrconv.GoError) =
  try:
    let s = parseHexStr(cast[string](src))
    for i in 0 ..< min(s.len, dst.len): dst[i] = byte(s[i])
    return (s.len, nil)
  except: return (0, gostrconv.GoError(msg: "invalid byte"))

proc DecodeString*(s: string): (seq[byte], gostrconv.GoError) =
  try:
    let res = parseHexStr(s)
    return (cast[seq[byte]](res), nil)
  except: return (@[], gostrconv.GoError(msg: "invalid byte"))

proc Dump*(data: seq[byte]): string =
  # Very simplified hex dump
  toHex(cast[string](data))
