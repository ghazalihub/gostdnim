import ../../errors/errors as goerrors

proc Marshal*(val: any): (seq[byte], goerrors.GoError) =
  return (@[], nil)

proc Unmarshal*(b: seq[byte], val: any): (seq[byte], goerrors.GoError) =
  return (@[], nil)
