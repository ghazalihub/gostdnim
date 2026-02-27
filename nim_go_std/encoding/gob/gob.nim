import ../../errors/errors as goerrors

proc Marshal*(v: any): (seq[byte], goerrors.GoError) = (@[], nil)
proc Unmarshal*(data: seq[byte], v: any): goerrors.GoError = nil
