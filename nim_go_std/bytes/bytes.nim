import std/[strutils, unicode, algorithm]
import ../errors/errors as goerrors

proc Equal*(a, b: seq[byte]): bool =
  if a.len != b.len: return false
  for i in 0 ..< a.len:
    if a[i] != b[i]: return false
  return true

proc Compare*(a, b: seq[byte]): int =
  let n = min(a.len, b.len)
  for i in 0 ..< n:
    if a[i] < b[i]: return -1
    if a[i] > b[i]: return 1
  if a.len < b.len: return -1
  if a.len > b.len: return 1
  return 0

proc Count*(s, sep: seq[byte]): int =
  if sep.len == 0:
    var count = 0
    var i = 0
    let str = cast[string](s)
    while i < s.len:
      let r = runeAt(str, i)
      count += 1
      i += r.size
    return count + 1
  var count = 0
  var i = 0
  while i <= s.len - sep.len:
    var match = true
    for j in 0 ..< sep.len:
      if s[i + j] != sep[j]:
        match = false
        break
    if match:
      count += 1
      i += sep.len
    else:
      i += 1
  return count

proc Contains*(s, subslice: seq[byte]): bool =
  if subslice.len == 0: return true
  for i in 0 .. s.len - subslice.len:
    var match = true
    for j in 0 ..< subslice.len:
      if s[i + j] != subslice[j]:
        match = false
        break
    if match: return true
  return false

proc ContainsAny*(b: seq[byte], chars: string): bool =
  let s = cast[string](b)
  for c in chars:
    if s.contains(c): return true
  return false

proc ContainsRune*(b: seq[byte], r: Rune): bool =
  let s = cast[string](b)
  return s.contains($r)

proc ContainsFunc*(b: seq[byte], f: proc(r: Rune): bool): bool =
  let s = cast[string](b)
  for r in s.runes:
    if f(r): return true
  return false

proc HasPrefix*(s, prefix: seq[byte]): bool =
  if s.len < prefix.len: return false
  for i in 0 ..< prefix.len:
    if s[i] != prefix[i]: return false
  return true

proc HasSuffix*(s, suffix: seq[byte]): bool =
  if s.len < suffix.len: return false
  let start = s.len - suffix.len
  for i in 0 ..< suffix.len:
    if s[start + i] != suffix[i]: return false
  return true

proc Index*(s, sep: seq[byte]): int =
  if sep.len == 0: return 0
  for i in 0 .. s.len - sep.len:
    var match = true
    for j in 0 ..< sep.len:
      if s[i + j] != sep[j]:
        match = false
        break
    if match: return i
  return -1

proc IndexByte*(b: seq[byte], c: byte): int =
  for i in 0 ..< b.len:
    if b[i] == c: return i
  return -1

proc IndexRune*(s: seq[byte], r: Rune): int =
  let str = cast[string](s)
  var i = 0
  for run in str.runes:
    if run == r: return i
    i += run.size
  return -1

proc IndexAny*(s: seq[byte], chars: string): int =
  for i in 0 ..< s.len:
    if chars.contains(char(s[i])): return i
  return -1

proc LastIndex*(s, sep: seq[byte]): int =
  if sep.len == 0: return s.len
  for i in countdown(s.len - sep.len, 0):
    var match = true
    for j in 0 ..< sep.len:
      if s[i + j] != sep[j]:
        match = false
        break
    if match: return i
  return -1

proc LastIndexByte*(s: seq[byte], c: byte): int =
  for i in countdown(s.len - 1, 0):
    if s[i] == c: return i
  return -1

proc LastIndexAny*(s: seq[byte], chars: string): int =
  for i in countdown(s.len - 1, 0):
    if chars.contains(char(s[i])): return i
  return -1

proc Join*(s: seq[seq[byte]], sep: seq[byte]): seq[byte] =
  if s.len == 0: return @[]
  var res: seq[byte]
  for i, v in s:
    if i > 0:
      for b in sep: res.add(b)
    for b in v: res.add(b)
  return res

proc Repeat*(b: seq[byte], count: int): seq[byte] =
  if count < 0: raise newException(ValueError, "negative Repeat count")
  if count == 0: return @[]
  var res: seq[byte]
  for i in 0 ..< count:
    for val in b: res.add(val)
  return res

proc Replace*(s, old, `new`: seq[byte], n: int): seq[byte] =
  if n == 0: return s
  var res: seq[byte]
  var i = 0
  var count = 0
  while i < s.len:
    if n > 0 and count >= n:
      for j in i ..< s.len: res.add(s[j])
      break
    var match = true
    if i + old.len <= s.len and old.len > 0:
      for j in 0 ..< old.len:
        if s[i + j] != old[j]:
          match = false
          break
    else: match = false
    if match:
      for val in `new`: res.add(val)
      i += old.len
      count += 1
    else:
      res.add(s[i])
      i += 1
  return res

proc ReplaceAll*(s, old, `new`: seq[byte]): seq[byte] = Replace(s, old, `new`, -1)

proc Split*(s, sep: seq[byte]): seq[seq[byte]] =
  var res: seq[seq[byte]]
  var i = 0
  if sep.len == 0:
    let str = cast[string](s)
    while i < s.len:
      let r = runeAt(str, i)
      var item: seq[byte]
      for j in 0 ..< r.size: item.add(s[i + j])
      res.add(item)
      i += r.size
    return res
  var last = 0
  while i <= s.len - sep.len:
    var match = true
    for j in 0 ..< sep.len:
      if s[i + j] != sep[j]:
        match = false
        break
    if match:
      res.add(s[last ..< i])
      i += sep.len
      last = i
    else: i += 1
  res.add(s[last .. ^1])
  return res

proc SplitN*(s, sep: seq[byte], n: int): seq[seq[byte]] =
  if n == 0: return @[]
  if n < 0: return Split(s, sep)
  if n == 1: return @[s]
  return Split(s, sep)[0 ..< min(n, Split(s, sep).len)]

proc ToLower*(s: seq[byte]): seq[byte] = cast[seq[byte]](cast[string](s).toLowerAscii)
proc ToUpper*(s: seq[byte]): seq[byte] = cast[seq[byte]](cast[string](s).toUpperAscii)

proc Trim*(s: seq[byte], cutset: string): seq[byte] =
  var charset: set[char]
  for c in cutset: charset.incl(c)
  let str = cast[string](s)
  let trimmed = strutils.strip(str, chars = charset)
  return cast[seq[byte]](trimmed)

proc TrimLeft*(s: seq[byte], cutset: string): seq[byte] =
  var charset: set[char]
  for c in cutset: charset.incl(c)
  return cast[seq[byte]](strutils.strip(cast[string](s), trailing = false, chars = charset))

proc TrimRight*(s: seq[byte], cutset: string): seq[byte] =
  var charset: set[char]
  for c in cutset: charset.incl(c)
  return cast[seq[byte]](strutils.strip(cast[string](s), leading = false, chars = charset))

proc TrimSpace*(s: seq[byte]): seq[byte] = cast[seq[byte]](strutils.strip(cast[string](s)))

proc TrimPrefix*(s, prefix: seq[byte]): seq[byte] =
  if HasPrefix(s, prefix): return s[prefix.len .. ^1]
  return s

proc TrimSuffix*(s, suffix: seq[byte]): seq[byte] =
  if HasSuffix(s, suffix): return s[0 ..< (s.len - suffix.len)]
  return s

proc Map*(mapping: proc(r: Rune): Rune, s: seq[byte]): seq[byte] =
  let str = cast[string](s)
  var res = ""
  for r in str.runes:
    let m = mapping(r)
    if int(m) >= 0: res.add($m)
  return cast[seq[byte]](res)

proc EqualFold*(s, t: seq[byte]): bool = cast[string](s).toLowerAscii == cast[string](t).toLowerAscii

proc Cut*(s, sep: seq[byte]): (seq[byte], seq[byte], bool) =
  let i = Index(s, sep)
  if i >= 0: return (s[0 ..< i], s[i + sep.len .. ^1], true)
  return (s, @[], false)

proc Clone*(b: seq[byte]): seq[byte] =
  if b.len == 0: return @[]
  return b

proc Runes*(s: seq[byte]): seq[Rune] = toRunes(cast[string](s))

type
  Buffer* = object
    buf: seq[byte]

proc NewBuffer*(buf: seq[byte]): Buffer = Buffer(buf: buf)
proc NewBufferString*(s: string): Buffer = Buffer(buf: cast[seq[byte]](s))

proc Write*(b: var Buffer, p: seq[byte]): (int, goerrors.GoError) =
  b.buf.add(p)
  return (p.len, nil)

proc WriteByte*(b: var Buffer, c: byte) = b.buf.add(c)
proc WriteString*(b: var Buffer, s: string): (int, goerrors.GoError) =
  for c in s: b.buf.add(byte(c))
  return (s.len, nil)

proc Len*(b: Buffer): int = b.buf.len
proc Reset*(b: var Buffer) = b.buf = @[]
proc Bytes*(b: Buffer): seq[byte] = b.buf
proc String*(b: Buffer): string = cast[string](b.buf)
