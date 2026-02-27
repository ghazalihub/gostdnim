import ../../errors/errors as goerrors
import std/json as nimjson

proc Marshal*(v: any): (seq[byte], goerrors.GoError) =
  try:
    let node = nimjson.`%`(v)
    return (cast[seq[byte]](nimjson.`$`(node)), nil)
  except:
    return (@[], goerrors.New("json: error marshaling"))

proc Unmarshal*(data: seq[byte], v: any): goerrors.GoError =
  try:
    let node = nimjson.parseJson(cast[string](data))
    v[] = node.to(type(v[]))
    return nil
  except:
    return goerrors.New("json: error unmarshaling")

proc HTMLEscape*(dst: var seq[byte], src: seq[byte]) =
  let s = cast[string](src)
  var res = ""
  for c in s:
    case c
    of '<': res.add("\\u003c")
    of '>': res.add("\\u003e")
    of '&': res.add("\\u0026")
    else: res.add(c)
  for b in cast[seq[byte]](res): dst.add(b)

proc Valid*(data: seq[byte]): bool =
  try:
    discard nimjson.parseJson(cast[string](data))
    return true
  except:
    return false
