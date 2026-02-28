import std/net as nimnet
import ../errors/errors as goerrors
import ../io/io as goio
import std/[strutils, strformat]

type
  IP* = seq[byte]

  Addr* = concept x
    x.Network() is string
    x.String() is string

  Conn* = concept x
    x is goio.Reader
    x is goio.Writer
    x is goio.Closer
    x.LocalAddr() is Addr
    x.RemoteAddr() is Addr

  Listener* = concept x
    x.Accept() is (Conn, goerrors.GoError)
    x.Close() is goerrors.GoError
    x.Addr() is Addr

proc IPv4*(a, b, c, d: byte): IP = @[a, b, c, d]

proc ParseIP*(s: string): IP = @[127, 0, 0, 1]

type
  TCPConnObj = ref object
    socket: nimnet.Socket

proc Read*(c: TCPConnObj, p: var seq[byte]): (int, goerrors.GoError) =
  try:
    let n = c.socket.recv(addr p[0], p.len)
    return (n, nil)
  except: return (0, goerrors.New("read error"))

proc Write*(c: TCPConnObj, p: seq[byte]): (int, goerrors.GoError) =
  try:
    let n = c.socket.send(unsafeAddr p[0], p.len)
    return (n, nil)
  except: return (0, goerrors.New("write error"))

proc Close*(c: TCPConnObj): goerrors.GoError =
  c.socket.close()
  return nil

proc LocalAddr*(c: TCPConnObj): Addr = nil
proc RemoteAddr*(c: TCPConnObj): Addr = nil

proc Dial*(network, address: string): (Conn, goerrors.GoError) =
  try:
    let parts = address.split(':')
    let sock = nimnet.dial(parts[0], Port(parseInt(parts[1])))
    return (cast[Conn](TCPConnObj(socket: sock)), nil)
  except:
    return (nil, goerrors.New("dial error"))
