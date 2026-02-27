import std/[strutils, strformat, unicode]
import ../io/io as goio
import ../errors/errors as goerrors
import ../strconv/strconv as gostrconv

# Mimicking Go's fmt package with a more robust parser

proc formatValue(val: string, verb: char): string =
  case verb
  of 'v', 's': return val
  of 'q': return gostrconv.Quote(val)
  of 'x':
    var res = ""
    for c in val: res.add(toHex(ord(c), 2).toLowerAscii)
    return res
  of 'X':
    var res = ""
    for c in val: res.add(toHex(ord(c), 2))
    return res
  else: return val

proc Sprintf*(format: string, a: varargs[string, `$`]): string =
  var res = ""
  var argIdx = 0
  var i = 0
  while i < format.len:
    if format[i] == '%' and i + 1 < format.len:
      i += 1
      if format[i] == '%':
        res.add('%')
        i += 1
        continue

      # Simple parser for flags, width, precision
      # For now, focus on the verb
      var verb = format[i]
      # skip flags/width for now if any
      while i < format.len and format[i] in {'0'..'9', '.', '-', '+', '#'}:
        i += 1
      if i < format.len:
        verb = format[i]

      if argIdx < a.len:
        res.add(formatValue(a[argIdx], verb))
        argIdx += 1
      i += 1
    else:
      res.add(format[i])
      i += 1
  return res

proc Sprint*(a: varargs[string, `$`]): string =
  a.join("")

proc Sprintln*(a: varargs[string, `$`]): string =
  a.join(" ") & "\n"

proc Fprintf*(w: var goio.Writer, format: string, a: varargs[string, `$`]): (int, goerrors.GoError) =
  let s = Sprintf(format, a)
  w.Write(cast[seq[byte]](s))

proc Fprint*(w: var goio.Writer, a: varargs[string, `$`]): (int, goerrors.GoError) =
  let s = Sprint(a)
  w.Write(cast[seq[byte]](s))

proc Fprintln*(w: var goio.Writer, a: varargs[string, `$`]): (int, goerrors.GoError) =
  let s = Sprintln(a)
  w.Write(cast[seq[byte]](s))

proc Printf*(format: string, a: varargs[string, `$`]) =
  stdout.write(Sprintf(format, a))

proc Print*(a: varargs[string, `$`]) =
  stdout.write(Sprint(a))

proc Println*(a: varargs[string, `$`]) =
  stdout.write(Sprintln(a))

proc Errorf*(format: string, a: varargs[string, `$`]): goerrors.GoError =
  goerrors.New(Sprintf(format, a))
