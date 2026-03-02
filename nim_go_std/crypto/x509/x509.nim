import ../../errors/errors as goerrors

type
  Certificate* = ref object

proc ParseCertificate*(der: seq[byte]): (Certificate, goerrors.GoError) =
  return (Certificate(), nil)
