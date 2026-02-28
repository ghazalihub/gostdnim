import std/strutils

type
  T* = ref object
    failed: bool

proc Error*(t: T, args: varargs[string, `$`]) =
  t.failed = true
  echo args.join(" ")

proc Fatal*(t: T, args: varargs[string, `$`]) =
  t.failed = true
  echo args.join(" ")
  raise newException(Exception, "Test failed")

proc Log*(t: T, args: varargs[string, `$`]) =
  echo args.join(" ")

proc Run*(t: T, name: string, f: proc(t: T)) =
  echo "Running test: ", name
  let subT = T(failed: false)
  try:
    f(subT)
  except:
    subT.failed = true
  if subT.failed:
    t.failed = true
    echo "Test ", name, " FAILED"
  else:
    echo "Test ", name, " PASSED"

type
  B* = ref object
    N*: int

proc StartTimer*(b: B) = discard
proc StopTimer*(b: B) = discard
proc ResetTimer*(b: B) = discard
