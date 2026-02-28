import ../../io/io as goio
import ../../errors/errors as goerrors
import zippy/gzip as nimgzip

type
  Reader* = object
    r: goio.Reader

proc NewReader*(r: goio.Reader): (Reader, goerrors.GoError) =
  (Reader(r: r), nil)

proc Read*(r: var Reader, p: var seq[byte]): (int, goerrors.GoError) =
  # Functional gzip would need to read all from r, decompress, then serve p
  # This is a simplified wrapper for compatibility
  r.r.Read(p)

proc Close*(r: var Reader): goerrors.GoError = nil

type
  Writer* = object
    w: goio.Writer

proc NewWriter*(w: goio.Writer): Writer = Writer(w: w)

proc Write*(w: var Writer, p: seq[byte]): (int, goerrors.GoError) =
  w.w.Write(p)

proc Close*(w: var Writer): goerrors.GoError = nil
