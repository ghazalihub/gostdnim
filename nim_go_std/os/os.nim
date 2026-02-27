import std/[os, strutils]
import ../errors/errors as goerrors

type
  File* = ref object
    handle: system.File
    name: string

proc Open*(name: string): (File, goerrors.GoError) =
  try:
    let f = open(name, fmRead)
    return (File(handle: f, name: name), nil)
  except:
    return (nil, goerrors.New("open " & name & ": no such file or directory"))

proc Create*(name: string): (File, goerrors.GoError) =
  try:
    let f = open(name, fmWrite)
    return (File(handle: f, name: name), nil)
  except:
    return (nil, goerrors.New("create " & name & ": error"))

proc Read*(f: File, p: var seq[byte]): (int, goerrors.GoError) =
  try:
    let n = f.handle.readBuffer(addr p[0], p.len)
    if n == 0: return (0, goerrors.New("EOF"))
    return (n, nil)
  except:
    return (0, goerrors.New("read error"))

proc Write*(f: File, p: seq[byte]): (int, goerrors.GoError) =
  try:
    let n = f.handle.writeBuffer(unsafeAddr p[0], p.len)
    return (n, nil)
  except:
    return (0, goerrors.New("write error"))

proc Close*(f: File): goerrors.GoError =
  try:
    f.handle.close()
    return nil
  except:
    return goerrors.New("close error")

proc Remove*(name: string): goerrors.GoError =
  try:
    removeFile(name)
    return nil
  except:
    return goerrors.New("remove error")

proc ReadFile*(name: string): (seq[byte], goerrors.GoError) =
  try:
    let content = readFile(name)
    return (cast[seq[byte]](content), nil)
  except:
    return (@[], goerrors.New("readfile error"))

proc WriteFile*(name: string, data: seq[byte], perm: int): goerrors.GoError =
  try:
    writeFile(name, cast[string](data))
    return nil
  except:
    return goerrors.New("writefile error")

proc Getenv*(key: string): string = getEnv(key)
proc Setenv*(key, value: string): goerrors.GoError =
  try:
    putEnv(key, value)
    return nil
  except:
    return goerrors.New("setenv error")

var Args* = commandLineParams()

proc Exit*(code: int) = quit(code)

proc Getwd*(): (string, goerrors.GoError) =
  try:
    return (getCurrentDir(), nil)
  except:
    return ("", goerrors.New("getwd error"))

proc Mkdir*(name: string, perm: int): goerrors.GoError =
  try:
    createDir(name)
    return nil
  except:
    return goerrors.New("mkdir error")
