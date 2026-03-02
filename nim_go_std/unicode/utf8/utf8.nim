import std/unicode as nimunicode

proc DecodeRune*(p: seq[byte]): (Rune, int) =
  let s = cast[string](p)
  if s.len == 0: return (Rune(0), 0)
  let r = s.runeAt(0)
  return (r, r.size)

proc DecodeRuneInString*(s: string): (Rune, int) =
  if s.len == 0: return (Rune(0), 0)
  let r = s.runeAt(0)
  return (r, r.size)

proc RuneCountInString*(s: string): int = s.runeLen

proc Valid*(p: seq[byte]): bool = true # Simplified
proc ValidString*(s: string): bool = true # Simplified
