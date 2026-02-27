import ../errors/errors as goerrors

type
  Reader* = concept var x
    x.Read(var seq[byte]) is (int, goerrors.GoError)

  Writer* = concept var x
    x.Write(seq[byte]) is (int, goerrors.GoError)

  Closer* = concept var x
    x.Close() is goerrors.GoError

  ReadCloser* = concept var x
    x is Reader
    x is Closer

  WriteCloser* = concept var x
    x is Writer
    x is Closer

  ReadWriter* = concept var x
    x is Reader
    x is Writer

  ReaderAt* = concept var x
    x.ReadAt(var seq[byte], int64) is (int, goerrors.GoError)

  WriterAt* = concept var x
    x.WriteAt(seq[byte], int64) is (int, goerrors.GoError)

var EOF* = goerrors.New("EOF")

proc ReadAll*(r: var Reader): (seq[byte], goerrors.GoError) =
  var res: seq[byte]
  var buf = newSeq[byte](4096)
  while true:
    let (n, err) = r.Read(buf)
    if n > 0:
      res.add(buf[0 ..< n])
    if err != nil:
      if err.msg == "EOF": return (res, nil)
      return (res, err)

proc WriteString*(w: var Writer, s: string): (int, goerrors.GoError) =
  w.Write(cast[seq[byte]](s))

proc ReadFull*(r: var Reader, buf: var seq[byte]): (int, goerrors.GoError) =
  var read = 0
  while read < buf.len:
    var subBuf = newSeq[byte](buf.len - read)
    let (n, err) = r.Read(subBuf)
    if n > 0:
      for i in 0 ..< n: buf[read + i] = subBuf[i]
      read += n
    if err != nil: return (read, err)
  return (read, nil)

proc Copy*(dst: var Writer, src: var Reader): (int64, goerrors.GoError) =
  var written: int64 = 0
  var buf = newSeq[byte](32 * 1024)
  while true:
    let (nr, rerr) = src.Read(buf)
    if nr > 0:
      let (nw, werr) = dst.Write(buf[0 ..< nr])
      if nw > 0: written += nw
      if werr != nil: return (written, werr)
    if rerr != nil:
      if rerr.msg == "EOF": return (written, nil)
      return (written, rerr)
