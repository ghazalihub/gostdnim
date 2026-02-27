import std/re
import ../errors/errors as goerrors

type
  Regexp* = ref object
    pattern: re.Regex

proc Compile*(expr: string): (Regexp, goerrors.GoError) =
  try:
    # Go uses RE2, Nim uses PCRE. Basic patterns should work.
    return (Regexp(pattern: re(expr)), nil)
  except:
    return (nil, goerrors.New("error parsing regexp"))

proc MustCompile*(expr: string): Regexp =
  let (r, err) = Compile(expr)
  if err != nil: raise newException(Exception, err.msg)
  return r

proc MatchString*(r: Regexp, s: string): bool =
  s.contains(r.pattern)

proc FindString*(r: Regexp, s: string): string =
  let m = s.findBounds(r.pattern)
  if m.first != -1: return s[m.first .. m.last]
  return ""

proc ReplaceAllString*(r: Regexp, src, repl: string): string =
  # Go's ReplaceAllString handles $1, etc. Nim's re module also handles this.
  src.replace(r.pattern, repl)

proc MatchString*(pattern: string, s: string): (bool, goerrors.GoError) =
  let (r, err) = Compile(pattern)
  if err != nil: return (false, err)
  return (r.MatchString(s), nil)
