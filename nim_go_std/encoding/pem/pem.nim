import ../../errors/errors as goerrors
import ../../io/io as goio
import ../base64/base64 as gobase64
import std/[strutils, tables]

type
  Block* = object
    Type*: string
    Headers*: Table[string, string]
    Bytes*: seq[byte]

proc Decode*(data: seq[byte]): (ref Block, seq[byte]) =
  let s = cast[string](data)
  let startIdx = s.find("-----BEGIN ")
  if startIdx == -1: return (nil, data)
  let endHeaderIdx = s.find("-----", startIdx + 11)
  if endHeaderIdx == -1: return (nil, data)
  let typeStr = s[startIdx + 11 ..< endHeaderIdx]

  let endIdx = s.find("-----END " & typeStr & "-----")
  if endIdx == -1: return (nil, data)

  var b = new(Block)
  b.Type = typeStr
  b.Headers = initTable[string, string]()

  let base64Start = s.find("\n", endHeaderIdx) + 1
  let base64Str = s[base64Start ..< endIdx].replace("\n", "").replace("\r", "").replace(" ", "")
  let (decoded, err) = gobase64.DecodeString(gobase64.StdEncoding, base64Str)
  if err == nil:
    b.Bytes = decoded

  return (b, cast[seq[byte]](s[endIdx + 14 + typeStr.len .. ^1]))

proc Encode*(out_w: var goio.Writer, b: Block): goerrors.GoError =
  var s = "-----BEGIN " & b.Type & "-----\n"
  for k, v in b.Headers:
    s.add(k & ": " & v & "\n")
  if b.Headers.len > 0: s.add("\n")

  let b64 = gobase64.EncodeToString(gobase64.StdEncoding, b.Bytes)
  var i = 0
  while i < b64.len:
    let chunk = min(64, b64.len - i)
    s.add(b64[i ..< i + chunk] & "\n")
    i += chunk

  s.add("-----END " & b.Type & "-----\n")
  let (n, err) = out_w.Write(cast[seq[byte]](s))
  return err

proc EncodeToMemory*(b: Block): seq[byte] = @[]
