import std/unicode as nimunicode

proc Encode*(s: seq[Rune]): seq[uint16] =
  var res: seq[uint16]
  for r in s:
    let code = int(r)
    if code <= 0xFFFF:
      res.add(uint16(code))
    else:
      # Surrogate pair logic
      let c = code - 0x10000
      res.add(uint16(0xD800 or (c shr 10)))
      res.add(uint16(0xDC00 or (c and 0x3FF)))
  return res

proc Decode*(s: seq[uint16]): seq[Rune] =
  var res: seq[Rune]
  var i = 0
  while i < s.len:
    let u1 = s[i]
    if u1 < 0xD800 or u1 > 0xDBFF:
      res.add(Rune(u1))
      i += 1
    elif i + 1 < s.len:
      let u2 = s[i+1]
      let code = 0x10000 or ((int(u1) and 0x3FF) shl 10) or (int(u2) and 0x3FF)
      res.add(Rune(code))
      i += 2
    else:
      res.add(Rune(u1))
      i += 1
  return res
