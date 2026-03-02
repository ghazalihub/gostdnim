import ../errors/errors as goerrors
import ../io as goio
import ../os/os as goos

proc ReadAll*(r: var goio.Reader): (seq[byte], goerrors.GoError) = goio.ReadAll(r)
proc ReadFile*(filename: string): (seq[byte], goerrors.GoError) = goos.ReadFile(filename)
proc WriteFile*(filename: string, data: seq[byte], perm: int): goerrors.GoError = goos.WriteFile(filename, data, perm)

proc TempDir*(dir, pattern: string): (string, goerrors.GoError) =
  return ("", nil) # Simplified
