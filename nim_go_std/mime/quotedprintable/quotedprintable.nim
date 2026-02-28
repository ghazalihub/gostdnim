import ../errors/errors as goerrors

proc Encode*(dst, src: seq[byte]): int = 0
proc Decode*(dst, src: seq[byte]): (int, goerrors.GoError) = (0, nil)
