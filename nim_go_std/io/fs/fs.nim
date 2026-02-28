import ../../errors/errors as goerrors
import ../../time/time as gotime

type
  FileInfo* = concept x
    x.Name() is string
    x.Size() is int64
    x.Mode() is int
    x.ModTime() is gotime.Time
    x.IsDir() is bool

  FS* = concept x
    x.Open(string) is (any, goerrors.GoError)

proc ReadFile*(fsys: FS, name: string): (seq[byte], goerrors.GoError) =
  return (@[], nil)

proc ReadDir*(fsys: FS, name: string): (seq[any], goerrors.GoError) =
  return (@[], nil)
