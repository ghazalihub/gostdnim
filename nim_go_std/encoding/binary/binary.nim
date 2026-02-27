import ../../errors/errors as goerrors
import ../../io/io as goio
import std/endians

type
  ByteOrder* = concept x
    x.Uint16(seq[byte]) is uint16
    x.Uint32(seq[byte]) is uint32
    x.Uint64(seq[byte]) is uint64
    x.PutUint16(var seq[byte], uint16)
    x.PutUint32(var seq[byte], uint32)
    x.PutUint64(var seq[byte], uint64)

type
  LittleEndianOrder* = object
  BigEndianOrder* = object

proc Uint16*(o: LittleEndianOrder, b: seq[byte]): uint16 =
  littleEndian16(addr result, unsafeAddr b[0])
proc Uint32*(o: LittleEndianOrder, b: seq[byte]): uint32 =
  littleEndian32(addr result, unsafeAddr b[0])
proc Uint64*(o: LittleEndianOrder, b: seq[byte]): uint64 =
  littleEndian64(addr result, unsafeAddr b[0])

proc PutUint16*(o: LittleEndianOrder, b: var seq[byte], v: uint16) =
  littleEndian16(addr b[0], unsafeAddr v)
proc PutUint32*(o: LittleEndianOrder, b: var seq[byte], v: uint32) =
  littleEndian32(addr b[0], unsafeAddr v)
proc PutUint64*(o: LittleEndianOrder, b: var seq[byte], v: uint64) =
  littleEndian64(addr b[0], unsafeAddr v)

proc Uint16*(o: BigEndianOrder, b: seq[byte]): uint16 =
  bigEndian16(addr result, unsafeAddr b[0])
proc Uint32*(o: BigEndianOrder, b: seq[byte]): uint32 =
  bigEndian32(addr result, unsafeAddr b[0])
proc Uint64*(o: BigEndianOrder, b: seq[byte]): uint64 =
  bigEndian64(addr result, unsafeAddr b[0])

proc PutUint16*(o: BigEndianOrder, b: var seq[byte], v: uint16) =
  bigEndian16(addr b[0], unsafeAddr v)
proc PutUint32*(o: BigEndianOrder, b: var seq[byte], v: uint32) =
  bigEndian32(addr b[0], unsafeAddr v)
proc PutUint64*(o: BigEndianOrder, b: var seq[byte], v: uint64) =
  bigEndian64(addr b[0], unsafeAddr v)

var LittleEndian*: LittleEndianOrder
var BigEndian*: BigEndianOrder

proc Read*(r: var goio.Reader, order: ByteOrder, data: any): goerrors.GoError =
  var size = 0
  when data is uint16: size = 2
  elif data is uint32: size = 4
  elif data is uint64: size = 8

  if size > 0:
    var buf = newSeq[byte](size)
    let (n, err) = r.Read(buf)
    if err != nil: return err
    if n < size: return goerrors.New("EOF")
    when data is uint16: data = order.Uint16(buf)
    elif data is uint32: data = order.Uint32(buf)
    elif data is uint64: data = order.Uint64(buf)
  return nil

proc Write*(w: var goio.Writer, order: ByteOrder, data: any): goerrors.GoError =
  var buf: seq[byte]
  when data is uint16:
    buf = newSeq[byte](2)
    order.PutUint16(buf, data)
  elif data is uint32:
    buf = newSeq[byte](4)
    order.PutUint32(buf, data)
  elif data is uint64:
    buf = newSeq[byte](8)
    order.PutUint64(buf, data)

  if buf.len > 0:
    let (n, err) = w.Write(buf)
    return err
  return nil

proc PutUvarint*(buf: var seq[byte], x: uint64): int =
  var i = 0
  var tx = x
  while tx >= 0x80:
    buf.add(byte(tx or 0x80))
    tx = tx shr 7
    i += 1
  buf.add(byte(tx))
  return i + 1

proc Uvarint*(buf: seq[byte]): (uint64, int) =
  var x: uint64 = 0
  var s: uint = 0
  for i, b in buf:
    if b < 0x80:
      return (x or (uint64(b) shl s), i + 1)
    x = x or (uint64(b and 0x7f) shl s)
    s += 7
  return (0, 0)
