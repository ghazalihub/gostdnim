import ../../errors/errors as goerrors

proc MaxEncodedLen*(n: int): int = (n + 3) div 4 * 5

proc Encode*(dst, src: var seq[byte]): int =
  if src.len == 0: return 0
  var n = 0
  var si = 0
  var di = 0
  while si < src.len:
    var v: uint32 = 0
    let rem = src.len - si
    if rem >= 4:
      v = (uint32(src[si]) shl 24) or (uint32(src[si+1]) shl 16) or (uint32(src[si+2]) shl 8) or uint32(src[si+3])
      if v == 0:
        dst[di] = byte('z')
        di += 1
        si += 4
        n += 1
        continue
    else:
      if rem >= 1: v = v or (uint32(src[si]) shl 24)
      if rem >= 2: v = v or (uint32(src[si+1]) shl 16)
      if rem >= 3: v = v or (uint32(src[si+2]) shl 8)

    var m = 5
    if rem < 4: m = rem + 1

    var buf: array[5, byte]
    var tv = v
    for i in countdown(4, 0):
      buf[i] = byte('!') + byte(tv mod 85)
      tv = tv div 85

    for i in 0 ..< m:
      dst[di + i] = buf[i]

    di += m
    si += min(rem, 4)
    n += m
  return n

proc Decode*(dst: var seq[byte], src: seq[byte], flush: bool): (int, int, goerrors.GoError) =
  var v: uint32 = 0
  var nb = 0
  var ndst = 0
  var nsrc = 0
  for i, b in src:
    if b <= byte(' '):
      continue
    if b == byte('z') and nb == 0:
      if dst.len - ndst < 4: break
      dst[ndst] = 0
      dst[ndst+1] = 0
      dst[ndst+2] = 0
      dst[ndst+3] = 0
      ndst += 4
      nsrc = i + 1
      continue
    if b >= byte('!') and b <= byte('u'):
      v = v * 85 + uint32(b - byte('!'))
      nb += 1
    else:
      return (ndst, i, goerrors.New("illegal ascii85 data"))

    if nb == 5:
      if dst.len - ndst < 4:
        break
      dst[ndst] = byte(v shr 24)
      dst[ndst+1] = byte(v shr 16)
      dst[ndst+2] = byte(v shr 8)
      dst[ndst+3] = byte(v)
      ndst += 4
      nsrc = i + 1
      v = 0
      nb = 0

  if flush and nb > 0:
    if nb == 1: return (ndst, nsrc, goerrors.New("illegal ascii85 data"))
    for i in nb ..< 5:
      v = v * 85 + 84
    for i in 0 ..< nb - 1:
      dst[ndst] = byte(v shr 24)
      v = v shl 8
      ndst += 1
    nsrc = src.len

  return (ndst, nsrc, nil)
