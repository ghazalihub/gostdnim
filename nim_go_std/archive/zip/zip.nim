import ../../io/io as goio
import ../../errors/errors as goerrors

type
  FileHeader* = object
    Name*: string

  File* = object
    FileHeader

  Reader* = object
    File*: seq[ptr File]

proc NewReader*(r: goio.ReaderAt, size: int64): (Reader, goerrors.GoError) =
  (Reader(), nil)

type
  Writer* = object
    w: goio.Writer

proc NewWriter*(w: goio.Writer): Writer = Writer(w: w)

proc Create*(w: var Writer, name: string): (goio.Writer, goerrors.GoError) =
  (nil, nil)

proc Close*(w: var Writer): goerrors.GoError = nil
