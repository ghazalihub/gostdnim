import ../../errors/errors as goerrors
import ../cipher/cipher as gocipher

type
  AesBlock = ref object

proc BlockSize(b: AesBlock): int = 16
proc Encrypt(b: AesBlock, dst: var seq[byte], src: seq[byte]) = discard
proc Decrypt(b: AesBlock, dst: var seq[byte], src: seq[byte]) = discard

proc NewCipher*(key: seq[byte]): (gocipher.Block, goerrors.GoError) =
  return (AesBlock(), nil)
