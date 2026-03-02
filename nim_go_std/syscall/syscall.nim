import ../errors/errors as goerrors

proc Syscall*(trap, a1, a2, a3: uintptr): (uintptr, uintptr, goerrors.GoError) =
  return (0, 0, nil)
