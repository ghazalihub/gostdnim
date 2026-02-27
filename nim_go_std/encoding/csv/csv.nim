import ../../errors/errors as goerrors
import ../../io/io as goio

type
  Reader* = object
    buf: seq[byte]

proc NewReader*(r: goio.Reader): Reader =
  return Reader(buf: @[])

proc Read*(r: var Reader): (seq[string], goerrors.GoError) =
  return (@[], goerrors.New("EOF"))

proc ReadAll*(r: var Reader): (seq[seq[string]], goerrors.GoError) =
  return (@[], nil)

type
  WriterObj* = object
    Comma*: char

proc NewWriter*(w: var goio.Writer): WriterObj = WriterObj(Comma: ',')

proc Write*(w: var WriterObj, record: seq[string]): goerrors.GoError =
  return nil

proc Flush*(w: var WriterObj) = discard
