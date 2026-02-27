import std/[os, strutils, parseutils]

type
  FlagValue = ref object
    kind: string
    s_ptr: ref string
    i_ptr: ref int
    b_ptr: ref bool
    name: string

  FlagSet* = ref object
    name: string
    parsed: bool
    args: seq[string]
    flags: seq[FlagValue]

proc NewFlagSet*(name: string, errorHandling: int): FlagSet =
  FlagSet(name: name, parsed: false, flags: @[])

var CommandLine* = NewFlagSet(os.getAppFilename(), 0)

proc Parse*(f: FlagSet, arguments: seq[string]): bool =
  f.parsed = true
  f.args = @[]
  var i = 0
  while i < arguments.len:
    let arg = arguments[i]
    if arg.startsWith("-"):
      let trimmed = if arg.startsWith("--"): arg[2..^1] else: arg[1..^1]
      let parts = trimmed.split('=', 1)
      let name = parts[0]
      var found = false
      for fv in f.flags:
        if fv.name == name:
          found = true
          if fv.kind == "bool":
            if parts.len > 1: fv.b_ptr[] = parseBool(parts[1])
            else: fv.b_ptr[] = true
          else:
            let val = if parts.len > 1: parts[1]
                      elif i + 1 < arguments.len:
                        i += 1
                        arguments[i]
                      else: ""
            if fv.kind == "string": fv.s_ptr[] = val
            elif fv.kind == "int": fv.i_ptr[] = parseInt(val)
          break
      if not found: f.args.add(arg)
    else:
      f.args.add(arg)
    i += 1
  return true

proc Parse*() =
  discard CommandLine.Parse(commandLineParams())

proc Parsed*(): bool = CommandLine.parsed

proc String*(f: FlagSet, name: string, value: string, usage: string): ref string =
  var res = new(string)
  res[] = value
  f.flags.add(FlagValue(kind: "string", s_ptr: res, name: name))
  return res

proc String*(name: string, value: string, usage: string): ref string =
  return CommandLine.String(name, value, usage)

proc Int*(f: FlagSet, name: string, value: int, usage: string): ref int =
  var res = new(int)
  res[] = value
  f.flags.add(FlagValue(kind: "int", i_ptr: res, name: name))
  return res

proc Int*(name: string, value: int, usage: string): ref int =
  return CommandLine.Int(name, value, usage)

proc Bool*(f: FlagSet, name: string, value: bool, usage: string): ref bool =
  var res = new(bool)
  res[] = value
  f.flags.add(FlagValue(kind: "bool", b_ptr: res, name: name))
  return res

proc Bool*(name: string, value: bool, usage: string): ref bool =
  return CommandLine.Bool(name, value, usage)

proc Args*(): seq[string] = CommandLine.args
proc NArg*(): int = CommandLine.args.len
proc Arg*(i: int): string =
  if i < CommandLine.args.len: return CommandLine.args[i]
  return ""
