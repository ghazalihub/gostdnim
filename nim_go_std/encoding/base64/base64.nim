import std/base64 as nimbase64
import ../../errors/errors as goerrors

type
  Encoding* = object
    alphabet: string
    padding: bool

proc NewEncoding*(encoder: string): Encoding = Encoding(alphabet: encoder, padding: true)

var StdEncoding* = NewEncoding("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")
var URLEncoding* = NewEncoding("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_")

proc EncodeToString*(enc: Encoding, src: seq[byte]): string =
  if enc.alphabet == URLEncoding.alphabet:
    return nimbase64.encode(cast[string](src), safe = true)
  return nimbase64.encode(cast[string](src))

proc DecodeString*(enc: Encoding, s: string): (seq[byte], goerrors.GoError) =
  try:
    return (cast[seq[byte]](nimbase64.decode(s)), nil)
  except: return (@[], goerrors.New("illegal base64 data"))

proc EncodedLen*(enc: Encoding, n: int): int = (n + 2) div 3 * 4
proc DecodedLen*(enc: Encoding, n: int): int = n div 4 * 3

proc Encode*(enc: Encoding, dst, src: var seq[byte]) =
  let res = EncodeToString(enc, src)
  for i, c in res:
    if i < dst.len: dst[i] = byte(c)

proc Decode*(enc: Encoding, dst, src: var seq[byte]): (int, goerrors.GoError) =
  try:
    let res = nimbase64.decode(cast[string](src))
    for i, b in res:
      if i < dst.len: dst[i] = byte(b)
    return (res.len, nil)
  except: return (0, goerrors.New("illegal base64 data"))
