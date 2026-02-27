import std/[strutils, times]
import ../fmt/fmt as gofmt
import ../io/io as goio

type
  Logger* = ref object
    prefix: string
    flags: int

proc New*(out_w: goio.Writer, prefix: string, flag: int): Logger =
  Logger(prefix: prefix, flags: flag)

proc Print*(v: varargs[string, `$`]) =
  echo gofmt.Sprint(v)

proc Printf*(format: string, v: varargs[string, `$`]) =
  echo gofmt.Sprintf(format, v)

proc Println*(v: varargs[string, `$`]) =
  echo gofmt.Sprintln(v)

proc Fatal*(v: varargs[string, `$`]) =
  echo gofmt.Sprint(v)
  quit(1)

proc Fatalf*(format: string, v: varargs[string, `$`]) =
  echo gofmt.Sprintf(format, v)
  quit(1)

proc Fatalln*(v: varargs[string, `$`]) =
  echo gofmt.Sprintln(v)
  quit(1)

proc Panic*(v: varargs[string, `$`]) =
  let s = gofmt.Sprint(v)
  raise newException(Exception, s)

proc Panicf*(format: string, v: varargs[string, `$`]) =
  let s = gofmt.Sprintf(format, v)
  raise newException(Exception, s)

proc Panicln*(v: varargs[string, `$`]) =
  let s = gofmt.Sprintln(v)
  raise newException(Exception, s)
