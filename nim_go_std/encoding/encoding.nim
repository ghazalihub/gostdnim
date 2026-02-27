import ../strconv/strconv as gostrconv

type
  BinaryMarshaler* = concept x
    x.MarshalBinary() is (seq[byte], gostrconv.GoError)

  BinaryUnmarshaler* = concept x
    x.UnmarshalBinary(seq[byte]) is gostrconv.GoError

  BinaryAppender* = concept x
    x.AppendBinary(seq[byte]) is (seq[byte], gostrconv.GoError)

  TextMarshaler* = concept x
    x.MarshalText() is (seq[byte], gostrconv.GoError)

  TextUnmarshaler* = concept x
    x.UnmarshalText(seq[byte]) is gostrconv.GoError

  TextAppender* = concept x
    x.AppendText(seq[byte]) is (seq[byte], gostrconv.GoError)
