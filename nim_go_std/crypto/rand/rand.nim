import std/sysrand
import ../../errors/errors as goerrors

proc Read*(b: var seq[byte]): (int, goerrors.GoError) =
  try:
    if sysrand.urandom(b):
      return (b.len, nil)
    else:
      return (0, goerrors.New("rand error"))
  except:
    return (0, goerrors.New("rand error"))
