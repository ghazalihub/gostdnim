import ../io/io as goio
import ../../errors/errors as goerrors

type
  Writer* = ref object
    output: goio.Writer

proc NewWriter*(output: var goio.Writer, minwidth, tabwidth, padding: int, padchar: byte, flags: uint): Writer =
  return Writer(output: output)

proc Flush*(w: Writer): goerrors.GoError = nil
proc Write*(w: Writer, b: seq[byte]): (int, goerrors.GoError) = w.output.Write(b)
