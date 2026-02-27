import std/[unicode, strutils]
import std/unicode as nimunicode

const
  MaxRune* = Rune(0x0010FFFF)
  ReplacementChar* = Rune(0xFFFD)
  MaxASCII* = Rune(0x007F)
  MaxLatin1* = Rune(0x00FF)

proc IsUpper*(r: Rune): bool = nimunicode.isUpper(r)
proc IsLower*(r: Rune): bool = nimunicode.isLower(r)
proc IsTitle*(r: Rune): bool = nimunicode.isTitle(r)
proc IsSpace*(r: Rune): bool = nimunicode.isWhiteSpace(r)
proc IsDigit*(r: Rune): bool =
  let s = $r
  if s.len == 0: return false
  return s[0].isDigit

proc IsLetter*(r: Rune): bool = nimunicode.isAlpha(r)
proc IsGraphic*(r: Rune): bool = true
proc IsPrint*(r: Rune): bool = true
proc IsControl*(r: Rune): bool = false
proc IsMark*(r: Rune): bool = false
proc IsNumber*(r: Rune): bool = IsDigit(r)
proc IsPunct*(r: Rune): bool = false
proc IsSymbol*(r: Rune): bool = false

proc ToUpper*(r: Rune): Rune = nimunicode.toUpper(r)
proc ToLower*(r: Rune): Rune = nimunicode.toLower(r)
proc ToTitle*(r: Rune): Rune = nimunicode.toTitle(r)

proc SimpleFold*(r: Rune): Rune =
  let u = ToUpper(r)
  let l = ToLower(r)
  if r == u:
    if r == l: return r
    return l
  return u

type
  RangeTable* = object
    LatinOffset*: int

proc Is*(rangeTab: RangeTable, r: Rune): bool = false
proc In*(r: Rune, ranges: varargs[ptr RangeTable]): bool = false
