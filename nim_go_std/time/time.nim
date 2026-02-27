import std/[times, os, strutils]
import ../errors/errors as goerrors

type
  Duration* = int64
  Time* = object
    t: times.DateTime

const
  Nanosecond*: Duration = 1
  Microsecond*: Duration = 1000 * Nanosecond
  Millisecond*: Duration = 1000 * Microsecond
  Second*: Duration = 1000 * Millisecond
  Minute*: Duration = 60 * Second
  Hour*: Duration = 60 * Minute

proc Now*(): Time = Time(t: times.now())

proc Sleep*(d: Duration) =
  os.sleep(int(d div Millisecond))

proc Since*(t: Time): Duration =
  let delta = times.now() - t.t
  return int64(delta.inMilliseconds * Millisecond)

proc translateLayout(layout: string): string =
  # Translate Go's 2006-01-02 15:04:05 to Nim's yyyy-MM-dd HH:mm:ss
  var res = layout
  res = res.replace("2006", "yyyy")
  res = res.replace("01", "MM")
  res = res.replace("02", "dd")
  res = res.replace("15", "HH")
  res = res.replace("04", "mm")
  res = res.replace("05", "ss")
  return res

proc Format*(t: Time, layout: string): string =
  t.t.format(translateLayout(layout))

proc Parse*(layout, value: string): (Time, goerrors.GoError) =
  try:
    let dt = times.parse(value, translateLayout(layout))
    return (Time(t: dt), nil)
  except:
    return (Time(), goerrors.New("parsing time error"))

proc Unix*(sec, nsec: int64): Time =
  Time(t: times.fromUnix(sec).local)

proc Unix*(t: Time): int64 =
  t.t.toTime().toUnix()
