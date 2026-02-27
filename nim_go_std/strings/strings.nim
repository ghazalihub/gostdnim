import std/[strutils, unicode]

proc Clone*(s: string): string = s

proc Compare*(a, b: string): int =
  if a < b: -1
  elif a > b: 1
  else: 0

proc Count*(s, substr: string): int =
  if substr.len == 0: return s.runeLen + 1
  s.count(substr)

proc Contains*(s, substr: string): bool = s.contains(substr)

proc ContainsAny*(s, chars: string): bool =
  for c in chars:
    if s.contains(c): return true
  return false

proc ContainsRune*(s: string, r: Rune): bool = s.contains($r)

proc ContainsFunc*(s: string, f: proc(r: Rune): bool): bool =
  for r in s.runes:
    if f(r): return true
  return false

proc HasPrefix*(s, prefix: string): bool = s.startsWith(prefix)
proc HasSuffix*(s, suffix: string): bool = s.endsWith(suffix)

proc Index*(s, substr: string): int = s.find(substr)

proc IndexAny*(s, chars: string): int =
  for i, c in s:
    if chars.contains(c): return i
  return -1

proc IndexByte*(s: string, b: byte): int = s.find(char(b))

proc IndexRune*(s: string, r: Rune): int =
  var i = 0
  for run in s.runes:
    if run == r: return i
    i += run.size
  return -1

proc IndexFunc*(s: string, f: proc(r: Rune): bool): int =
  var i = 0
  for r in s.runes:
    if f(r): return i
    i += r.size
  return -1

proc LastIndex*(s, substr: string): int = s.rfind(substr)

proc LastIndexAny*(s, chars: string): int =
  for i in countdown(s.len - 1, 0):
    if chars.contains(s[i]): return i
  return -1

proc LastIndexByte*(s: string, b: byte): int = s.rfind(char(b))

proc LastIndexFunc*(s: string, f: proc(r: Rune): bool): int =
  var i = 0
  var last = -1
  for r in s.runes:
    if f(r): last = i
    i += r.size
  return last

proc Join*(elems: seq[string], sep: string): string = elems.join(sep)
proc Repeat*(s: string, count: int): string = s.repeat(count)

proc Replace*(s, old, new: string, n: int): string =
  if n < 0: return s.replace(old, new)
  if n == 0: return s
  var res = s
  var count = 0
  var i = 0
  while count < n:
    let idx = res.find(old, i)
    if idx == -1: break
    res.delete(idx .. idx + old.len - 1)
    res.insert(new, idx)
    i = idx + new.len
    count += 1
  return res

proc ReplaceAll*(s, old, new: string): string = s.replace(old, new)

proc Split*(s, sep: string): seq[string] =
  if sep == "":
    var res: seq[string]
    for r in s.runes: res.add($r)
    return res
  s.split(sep)

proc SplitN*(s, sep: string, n: int): seq[string] =
  if n == 0: return @[]
  if n < 0: return Split(s, sep)
  if n == 1: return @[s]
  if sep == "":
    var res: seq[string]
    var i = 0
    for r in s.runes:
      if i < n - 1:
        res.add($r)
        i += 1
      else: break
    return res
  return s.split(sep, n - 1)

proc SplitAfter*(s, sep: string): seq[string] =
  if sep == "": return Split(s, sep)
  var res: seq[string]
  var last = 0
  var i = 0
  while i <= s.len - sep.len:
    if s[i ..< i + sep.len] == sep:
      res.add(s[last .. i + sep.len - 1])
      i += sep.len
      last = i
    else: i += 1
  if last < s.len: res.add(s[last .. ^1])
  return res

proc Fields*(s: string): seq[string] = strutils.splitWhitespace(s)

proc FieldsFunc*(s: string, f: proc(r: Rune): bool): seq[string] =
  var res: seq[string]
  var start = -1
  var i = 0
  for r in s.runes:
    if f(r):
      if start >= 0:
        res.add(s[start .. i - 1])
        start = -1
    else:
      if start < 0: start = i
    i += r.size
  if start >= 0: res.add(s[start .. ^1])
  return res

proc ToLower*(s: string): string =
  var res = ""
  for r in s.runes: res.add($unicode.toLower(r))
  return res

proc ToUpper*(s: string): string =
  var res = ""
  for r in s.runes: res.add($unicode.toUpper(r))
  return res

proc ToTitle*(s: string): string =
  var res = ""
  for r in s.runes: res.add($unicode.toUpper(r))
  return res

proc Trim*(s, cutset: string): string =
  let cutsetRunes = cutset.toRunes
  var start = 0
  while start < s.len:
    let r = s.runeAt(start)
    if r notin cutsetRunes: break
    start += r.size
  var stop = s.len - 1
  while stop >= start:
    var i = start
    var lastRune = Rune(0)
    var lastIdx = start
    while i <= stop:
      lastIdx = i
      lastRune = s.runeAt(i)
      i += lastRune.size
    if lastRune notin cutsetRunes:
      break
    stop = lastIdx - 1
  if start > stop: return ""
  return s[start .. stop]

proc TrimLeft*(s, cutset: string): string =
  let cutsetRunes = cutset.toRunes
  var start = 0
  while start < s.len:
    let r = s.runeAt(start)
    if r notin cutsetRunes: break
    start += r.size
  return s[start .. ^1]

proc TrimRight*(s, cutset: string): string =
  let cutsetRunes = cutset.toRunes
  var stop = s.len - 1
  var start = 0
  while stop >= start:
    var i = start
    var lastRune = Rune(0)
    var lastIdx = start
    while i <= stop:
      lastIdx = i
      lastRune = s.runeAt(i)
      i += lastRune.size
    if lastRune notin cutsetRunes:
      break
    stop = lastIdx - 1
  if stop < 0: return ""
  return s[0 .. stop]

proc TrimSpace*(s: string): string = strutils.strip(s)

proc TrimPrefix*(s, prefix: string): string =
  if s.startsWith(prefix): return s[prefix.len .. ^1]
  return s

proc TrimSuffix*(s, suffix: string): string =
  if s.endsWith(suffix): return s[0 ..< (s.len - suffix.len)]
  return s

proc Map*(mapping: proc(r: Rune): Rune, s: string): string =
  var res = ""
  for r in s.runes:
    let m = mapping(r)
    if int(m) >= 0: res.add($m)
  return res

proc EqualFold*(s, t: string): bool = s.toLowerAscii == t.toLowerAscii

proc Cut*(s, sep: string): (string, string, bool) =
  let i = s.find(sep)
  if i >= 0: return (s[0 ..< i], s[i + sep.len .. ^1], true)
  return (s, "", false)

proc CutPrefix*(s, prefix: string): (string, bool) =
  if s.startsWith(prefix): return (s[prefix.len .. ^1], true)
  return (s, false)

proc CutSuffix*(s, suffix: string): (string, bool) =
  if s.endsWith(suffix): return (s[0 ..< (s.len - suffix.len)], true)
  return (s, false)

type
  Builder* = object
    buf: string

proc Write*(b: var Builder, p: seq[byte]): (int, ref Exception) =
  for x in p: b.buf.add(char(x))
  return (p.len, nil)

proc WriteByte*(b: var Builder, c: byte) = b.buf.add(char(c))
proc WriteRune*(b: var Builder, r: Rune) = b.buf.add($r)
proc WriteString*(b: var Builder, s: string): (int, ref Exception) =
  b.buf.add(s)
  return (s.len, nil)

proc Len*(b: Builder): int = b.buf.len
proc Cap*(b: Builder): int = b.buf.len
proc Reset*(b: var Builder) = b.buf = ""
proc String*(b: Builder): string = b.buf
