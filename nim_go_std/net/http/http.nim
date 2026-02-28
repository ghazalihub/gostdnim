import std/httpclient
import ../../errors/errors as goerrors
import ../../io/io as goio

type
  Response* = ref object
    Status*: string
    StatusCode*: int

proc Get*(url: string): (Response, goerrors.GoError) =
  try:
    let client = newHttpClient()
    let resp = client.get(url)
    return (Response(Status: resp.status, StatusCode: resp.code.int), nil)
  except:
    return (nil, goerrors.New("http get error"))

type
  ResponseWriter* = concept x
    x.Header() is auto
    x.Write(seq[byte]) is (int, goerrors.GoError)
    x.WriteHeader(int)

  Request* = ref object
    Method*: string
    URL*: auto
    Header*: auto

proc HandleFunc*(pattern: string, handler: proc(w: ResponseWriter, r: Request)) =
  discard
