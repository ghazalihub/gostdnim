import std/[httpclient, asynchttpserver, asyncdispatch, tables, strutils]
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

  Handler* = concept x
    x.ServeHTTP(ResponseWriter, Request)

  ServeMux* = ref object
    handlers: Table[string, RootRef] # Use RootRef for generic proc storage

proc NewServeMux*(): ServeMux = ServeMux(handlers: initTable[string, RootRef]())

proc HandleFunc*(mux: ServeMux, pattern: string, handler: any) =
  mux.handlers[pattern] = cast[RootRef](handler)

proc Handle*(mux: ServeMux, pattern: string, handler: Handler) =
  mux.handlers[pattern] = cast[RootRef](handler)

var DefaultServeMux* = NewServeMux()

proc HandleFunc*(pattern: string, handler: any) =
  DefaultServeMux.HandleFunc(pattern, handler)

proc Handle*(pattern: string, handler: Handler) =
  DefaultServeMux.Handle(pattern, handler)

proc ListenAndServe*(addr_str: string, handler: Handler): goerrors.GoError =
  return nil
