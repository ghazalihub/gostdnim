import ../../errors/errors as goerrors

type
  PrivateKey* = ref object
  PublicKey* = ref object

proc GenerateKey*(curve: any, random: any): (PrivateKey, goerrors.GoError) =
  return (nil, goerrors.New("not implemented"))
