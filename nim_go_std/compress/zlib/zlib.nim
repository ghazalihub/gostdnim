import ../../io/io as goio
import ../../errors/errors as goerrors
import zippy/zlib as nimzlib

type
  Reader* = object
    r: goio.Reader

proc NewReader*(r: goio.Reader): (goio.ReadCloser, goerrors.GoError) =
  (nil, nil)

type
  Writer* = object
    w: goio.Writer

proc NewWriter*(w: goio.Writer): Writer = Writer(w: w)

proc Write*(w: var Writer, p: seq[byte]): (int, goerrors.GoError) =
  w.w.Write(p)

proc Close*(w: var Writer): goerrors.GoError = nil
