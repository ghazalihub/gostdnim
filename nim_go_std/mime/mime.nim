import ../errors/errors as goerrors
import std/[strutils, tables]

proc TypeByExtension*(ext: string): string =
  case ext.toLowerAscii()
  of ".html": return "text/html; charset=utf-8"
  of ".css": return "text/css; charset=utf-8"
  of ".js": return "text/javascript; charset=utf-8"
  of ".json": return "application/json"
  of ".png": return "image/png"
  of ".jpg", ".jpeg": return "image/jpeg"
  else: return ""

proc ExtensionsByType*(typ: string): (seq[string], goerrors.GoError) =
  if typ == "text/html": return (@[".html"], nil)
  return (@[], nil)

proc ParseMediaType*(v: string): (string, Table[string, string], goerrors.GoError) =
  let parts = v.split(';')
  let mediatype = parts[0].strip().toLowerAscii()
  var params = initTable[string, string]()
  for i in 1 ..< parts.len:
    let kv = parts[i].split('=')
    if kv.len == 2:
      params[kv[0].strip().toLowerAscii()] = kv[1].strip()
  return (mediatype, params, nil)

proc FormatMediaType*(t: string, param: Table[string, string]): string =
  var res = t.toLowerAscii()
  for k, v in param:
    res.add("; " & k.toLowerAscii() & "=" & v)
  return res
