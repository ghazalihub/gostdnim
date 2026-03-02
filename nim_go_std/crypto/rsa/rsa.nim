import ../../errors/errors as goerrors

type
  PrivateKey* = ref object
  PublicKey* = ref object

proc GenerateKey*(random: any, bits: int): (PrivateKey, goerrors.GoError) =
  return (nil, goerrors.New("not implemented"))
