import ../../errors/errors as goerrors

type
  Block* = concept x
    x.BlockSize() is int
    x.Encrypt(var seq[byte], seq[byte])
    x.Decrypt(var seq[byte], seq[byte])

  Stream* = concept x
    x.XORKeyStream(var seq[byte], seq[byte])

  BlockMode* = concept x
    x.BlockSize() is int
    x.CryptBlocks(var seq[byte], seq[byte])
