import ../../errors/errors as goerrors

type
  Encoding* = object
    encode: array[32, byte]
    decodeMap: array[256, uint8]
    padChar: int

const
  StdPadding* = ord('=')
  NoPadding* = -1

proc NewEncoding*(encoder: string): Encoding =
  var res: Encoding
  res.padChar = StdPadding
  for i in 0 ..< 32:
    res.encode[i] = byte(encoder[i])
  for i in 0 ..< 256:
    res.decodeMap[i] = 0xFF
  for i in 0 ..< 32:
    res.decodeMap[ord(encoder[i])] = uint8(i)
  return res

var StdEncoding* = NewEncoding("ABCDEFGHIJKLMNOPQRSTUVWXYZ234567")
var HexEncoding* = NewEncoding("0123456789ABCDEFGHIJKLMNOPQRSTUV")

proc EncodedLen*(enc: Encoding, n: int): int =
  if enc.padChar == NoPadding:
    return n * 8 div 5 + (n * 8 mod 5 + 4) div 5
  return (n + 4) div 5 * 8

proc Encode*(enc: Encoding, dst: var seq[byte], src: seq[byte]) =
  if src.len == 0: return
  var di, si = 0
  let n = (src.len div 5) * 5
  while si < n:
    let hi = (uint32(src[si]) shl 24) or (uint32(src[si+1]) shl 16) or (uint32(src[si+2]) shl 8) or uint32(src[si+3])
    let lo = (hi shl 8) or uint32(src[si+4])
    dst[di+0] = enc.encode[(hi shr 27) and 0x1F]
    dst[di+1] = enc.encode[(hi shr 22) and 0x1F]
    dst[di+2] = enc.encode[(hi shr 17) and 0x1F]
    dst[di+3] = enc.encode[(hi shr 12) and 0x1F]
    dst[di+4] = enc.encode[(hi shr 7) and 0x1F]
    dst[di+5] = enc.encode[(hi shr 2) and 0x1F]
    dst[di+6] = enc.encode[(lo shr 5) and 0x1F]
    dst[di+7] = enc.encode[lo and 0x1F]
    si += 5
    di += 8

  let remain = src.len - si
  if remain > 0:
    var val: uint32 = 0
    if remain >= 1: val = val or (uint32(src[si]) shl 24)
    if remain >= 2: val = val or (uint32(src[si+1]) shl 16)
    if remain >= 3: val = val or (uint32(src[si+2]) shl 8)
    if remain >= 4: val = val or uint32(src[si+3])

    dst[di+0] = enc.encode[(val shr 27) and 0x1F]
    if remain >= 1: dst[di+1] = enc.encode[(val shr 22) and 0x1F]
    if remain >= 2:
      dst[di+2] = enc.encode[(val shr 17) and 0x1F]
      dst[di+3] = enc.encode[(val shr 12) and 0x1F]
    if remain >= 3:
      dst[di+4] = enc.encode[(val shr 7) and 0x1F]
    if remain >= 4:
      dst[di+5] = enc.encode[(val shr 2) and 0x1F]
      dst[di+6] = enc.encode[(val shl 3) and 0x1F]

    if enc.padChar != NoPadding:
      let nPad = (remain * 8 + 4) div 5
      for i in nPad ..< 8:
        dst[di + i] = byte(enc.padChar)

proc EncodeToString*(enc: Encoding, src: seq[byte]): string =
  var dst = newSeq[byte](enc.EncodedLen(src.len))
  enc.Encode(dst, src)
  return cast[string](dst)

proc DecodedLen*(enc: Encoding, n: int): int =
  if enc.padChar == NoPadding:
    return n * 5 div 8
  return n div 8 * 5

proc Decode*(enc: Encoding, dst: var seq[byte], src: seq[byte]): (int, goerrors.GoError) =
  return (0, nil)

proc DecodeString*(enc: Encoding, s: string): (seq[byte], goerrors.GoError) =
  return (@[], nil)
