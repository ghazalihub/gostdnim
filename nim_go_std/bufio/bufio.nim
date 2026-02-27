import ../io/io as goio
import ../errors/errors as goerrors

const defaultBufSize = 4096

type
  Reader* = object
    rd: goio.Reader
    buf: seq[byte]
    r, w: int # read and write positions
    err: goerrors.GoError

proc NewReaderSize*(rd: goio.Reader, size: int): Reader =
  Reader(rd: rd, buf: newSeq[byte](size), r: 0, w: 0)

proc NewReader*(rd: goio.Reader): Reader = NewReaderSize(rd, defaultBufSize)

proc fill(r: var Reader) =
  if r.r > 0:
    for i in 0 ..< r.w - r.r:
      r.buf[i] = r.buf[r.r + i]
    r.w -= r.r
    r.r = 0
  let (n, err) = r.rd.Read(r.buf[r.w .. ^1])
  r.w += n
  r.err = err

proc Read*(r: var Reader, p: var seq[byte]): (int, goerrors.GoError) =
  if p.len == 0: return (0, r.err)
  if r.r == r.w:
    if r.err != nil: return (0, r.err)
    r.fill()
    if r.r == r.w: return (0, r.err)

  let n = min(p.len, r.w - r.r)
  for i in 0 ..< n: p[i] = r.buf[r.r + i]
  r.r += n
  return (n, nil)

type
  Writer* = object
    wr: goio.Writer
    buf: seq[byte]
    n: int
    err: goerrors.GoError

proc NewWriterSize*(wr: goio.Writer, size: int): Writer =
  Writer(wr: wr, buf: newSeq[byte](size), n: 0)

proc NewWriter*(wr: goio.Writer): Writer = NewWriterSize(wr, defaultBufSize)

proc Flush*(w: var Writer): goerrors.GoError =
  if w.err != nil: return w.err
  if w.n == 0: return nil
  let (n, err) = w.wr.Write(w.buf[0 ..< w.n])
  if n < w.n and err == nil:
    w.err = goerrors.New("short write")
  else:
    w.err = err
  if w.err == nil:
    w.n = 0
  return w.err

proc Write*(w: var Writer, p: seq[byte]): (int, goerrors.GoError) =
  var n = 0
  var p = p
  while p.len > (w.buf.len - w.n) and w.err == nil:
    let chunk = w.buf.len - w.n
    for i in 0 ..< chunk: w.buf[w.n + i] = p[i]
    w.n += chunk
    discard w.Flush()
    n += chunk
    p = p[chunk .. ^1]
  if w.err != nil: return (n, w.err)
  for i in 0 ..< p.len: w.buf[w.n + i] = p[i]
  w.n += p.len
  n += p.len
  return (n, nil)

type
  Scanner* = object
    r: goio.Reader
    token: seq[byte]
    err: goerrors.GoError
    buf: seq[byte]
    start, `end`: int
    eof: bool

proc NewScanner*(r: goio.Reader): Scanner =
  Scanner(r: r, buf: newSeq[byte](defaultBufSize))

proc Scan*(s: var Scanner): bool =
  while true:
    if s.`end` > s.start:
      # Simplified: find newline
      for i in s.start ..< s.`end`:
        if s.buf[i] == byte('\n'):
          s.token = s.buf[s.start ..< i]
          s.start = i + 1
          return true
    if s.eof:
      if s.`end` > s.start:
        s.token = s.buf[s.start ..< s.`end`]
        s.start = s.`end`
        return true
      return false

    if s.start > 0:
      for i in 0 ..< s.`end` - s.start:
        s.buf[i] = s.buf[s.start + i]
      s.`end` -= s.start
      s.start = 0

    let (n, err) = s.r.Read(s.buf[s.`end` .. ^1])
    s.`end` += n
    if err != nil:
      s.err = if err.msg == "EOF": nil else: err
      s.eof = true

proc Bytes*(s: Scanner): seq[byte] = s.token
proc Text*(s: Scanner): string = cast[string](s.token)
proc Err*(s: Scanner): goerrors.GoError = s.err
