import ../../errors/errors as goerrors

type
  DB* = ref object
  Rows* = ref object

proc Open*(driverName, dataSourceName: string): (DB, goerrors.GoError) =
  return (DB(), nil)

proc Close*(db: DB): goerrors.GoError = nil

proc Query*(db: DB, query: string, args: varargs[auto]): (Rows, goerrors.GoError) =
  return (Rows(), nil)

proc Next*(rs: Rows): bool = false
proc Close*(rs: Rows): goerrors.GoError = nil
proc Scan*(rs: Rows, dest: varargs[auto]): goerrors.GoError = nil
