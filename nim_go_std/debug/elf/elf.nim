import ../../errors/errors as goerrors

type
  File* = ref object

proc Open*(name: string): (File, goerrors.GoError) =
  return (nil, goerrors.New("not implemented"))
