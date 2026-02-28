import std/uri
import ../../errors/errors as goerrors

type
  URL* = ref object
    Scheme*, Opaque*, User*, Host*, Path*, RawPath*, ForceQuery*, RawQuery*, Fragment*, RawFragment*: string

proc Parse*(rawURL: string): (URL, goerrors.GoError) =
  try:
    let u = parseUri(rawURL)
    return (URL(Scheme: u.scheme, Host: u.hostname & (if u.port != "": ":" & u.port else: ""), Path: u.path, RawQuery: u.query, Fragment: u.anchor), nil)
  except:
    return (nil, goerrors.New("parse error"))

proc QueryEscape*(s: string): string =
  uri.encodeUrl(s)

proc QueryUnescape*(s: string): (string, goerrors.GoError) =
  try:
    return (uri.decodeUrl(s), nil)
  except:
    return ("", goerrors.New("unescape error"))
