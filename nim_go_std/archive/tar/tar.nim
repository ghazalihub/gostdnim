import ../../io/io as goio
import ../../errors/errors as goerrors
import std/streams

type
  Header* = object
    Name*: string
    Size*: int64

  Reader* = object
    r: goio.Reader

proc NewReader*(r: goio.Reader): Reader = Reader(r: r)

proc Next*(r: var Reader): (Header, goerrors.GoError) =
  (Header(), goerrors.New("EOF"))

type
  Writer* = object
    w: goio.Writer

proc NewWriter*(w: goio.Writer): Writer = Writer(w: w)

proc WriteHeader*(w: var Writer, hdr: Header): goerrors.GoError = nil
proc Write*(w: var Writer, b: seq[byte]): (int, goerrors.GoError) = (b.len, nil)
proc Close*(w: var Writer): goerrors.GoError = nil
