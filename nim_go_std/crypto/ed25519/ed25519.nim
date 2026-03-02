import ../../errors/errors as goerrors

type
  PrivateKey* = seq[byte]
  PublicKey* = seq[byte]

proc GenerateKey*(random: any): (PublicKey, PrivateKey, goerrors.GoError) =
  return (@[], @[], goerrors.New("not implemented"))
