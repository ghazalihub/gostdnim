import std/[osproc, strutils]
import ../../errors/errors as goerrors

type
  Cmd* = ref object
    Path*: string
    Args*: seq[string]

proc Command*(name: string, arg: varargs[string]): Cmd =
  return Cmd(Path: name, Args: @[name] & @arg)

proc Run*(c: Cmd): goerrors.GoError =
  try:
    let code = execProcesses(@[c.Path & " " & c.Args[1 .. ^1].join(" ")])
    return nil
  except:
    return goerrors.New("exec error")

proc Output*(c: Cmd): (seq[byte], goerrors.GoError) =
  try:
    let output = execProcess(c.Path, args = c.Args[1 .. ^1])
    return (cast[seq[byte]](output), nil)
  except:
    return (@[], goerrors.New("exec error"))
