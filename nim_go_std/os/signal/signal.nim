import ../../errors/errors as goerrors

type
  Signal* = int

proc Notify*(c: any, sig: varargs[Signal]) = discard
proc Stop*(c: any) = discard
