type
  Hash* = concept x
    x.Write(seq[byte]) is (int, ref Exception)
    x.Sum(seq[byte]) is seq[byte]
    x.Reset()
    x.Size() is int
    x.BlockSize() is int

  Hash32* = concept x
    x is Hash
    x.Sum32() is uint32

  Hash64* = concept x
    x is Hash
    x.Sum64() is uint64
