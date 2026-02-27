import std/[strutils, parseutils, unicode]

type
  GoError* = ref object
    msg*: string

proc Error*(e: GoError): string =
  if e == nil: return ""
  return e.msg

proc `$`*(e: GoError): string = Error(e)
proc NewGoError(msg: string): GoError = GoError(msg: msg)

proc Atoi*(s: string): (int, GoError) =
  try: return (parseInt(s), nil)
  except ValueError: return (0, NewGoError("invalid syntax"))

proc Itoa*(i: int): string = $i

proc FormatInt*(i: int64, base: int): string =
  if i == 0: return "0"
  case base
  of 10: return $i
  of 16: return toHex(i).toLowerAscii.strip(leading = true, trailing = false, chars = {'0'})
  of 8: return toOct(i, 1).strip(leading = true, trailing = false, chars = {'0'})
  of 2: return toBin(i, 1).strip(leading = true, trailing = false, chars = {'0'})
  else: return $i

proc FormatUint*(i: uint64, base: int): string =
  if i == 0: return "0"
  case base
  of 10: return $i
  else: return $i # Simplified

proc ParseInt*(s: string, base: int, bitSize: int): (int64, GoError) =
  try:
    var res: int64
    if base == 0:
      if s.startsWith("0x") or s.startsWith("0X"): discard parseHex(s, res)
      elif s.startsWith("0") and s.len > 1: discard parseOct(s, res)
      else: res = parseBiggestInt(s)
    elif base == 16: discard parseHex(s, res)
    elif base == 8: discard parseOct(s, res)
    elif base == 2: discard parseBin(s, res)
    else: res = parseBiggestInt(s)
    return (res, nil)
  except ValueError: return (0, NewGoError("invalid syntax"))

proc ParseUint*(s: string, base: int, bitSize: int): (uint64, GoError) =
  try:
    var res: uint64
    discard parseBiggestUInt(s, res)
    return (res, nil)
  except ValueError: return (0, NewGoError("invalid syntax"))

proc ParseFloat*(s: string, bitSize: int): (float64, GoError) =
  try: return (parseFloat(s), nil)
  except ValueError: return (0.0, NewGoError("invalid syntax"))

proc ParseBool*(str: string): (bool, GoError) =
  case str.toLowerAscii
  of "1", "t", "true": return (true, nil)
  of "0", "f", "false": return (false, nil)
  else: return (false, NewGoError("invalid syntax"))

proc FormatBool*(b: bool): string =
  if b: return "true"
  else: return "false"

proc FormatFloat*(f: float64, fmt: char, prec, bitSize: int): string =
  f.formatFloat(ffDefault, prec)

proc Quote*(s: string): string = escape(s)
proc QuoteToASCII*(s: string): string = Quote(s) # Simplified
proc QuoteRune*(r: Rune): string = escape($r)

proc Unquote*(s: string): (string, GoError) =
  try: return (unescape(s), nil)
  except ValueError: return ("", NewGoError("invalid syntax"))

proc CanBackquote*(s: string): bool = not s.contains('`') and not s.contains('\r')

proc IsPrint*(r: Rune): bool = true # Simplified
proc IsGraphic*(r: Rune): bool = true # Simplified

proc AppendBool*(dst: var seq[byte], b: bool): seq[byte] =
  for c in FormatBool(b): dst.add(byte(c))
  return dst

proc AppendInt*(dst: var seq[byte], i: int64, base: int): seq[byte] =
  for c in FormatInt(i, base): dst.add(byte(c))
  return dst

proc AppendUint*(dst: var seq[byte], i: uint64, base: int): seq[byte] =
  for c in FormatUint(i, base): dst.add(byte(c))
  return dst
