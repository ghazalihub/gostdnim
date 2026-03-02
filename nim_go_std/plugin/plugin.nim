import ../errors/errors as goerrors

type
  Plugin* = ref object

proc Open*(path: string): (Plugin, goerrors.GoError) =
  return (nil, goerrors.New("plugin not supported"))
