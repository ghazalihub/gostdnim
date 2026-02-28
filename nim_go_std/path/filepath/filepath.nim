import std/os as nimos
import ../../errors/errors as goerrors

proc Match*(pattern, name: string): (bool, goerrors.GoError) = (false, nil)
proc Glob*(pattern: string): (seq[string], goerrors.GoError) = (@[], nil)
proc Clean*(path: string): string = nimos.normalizedPath(path)
proc IsLocal*(path: string): bool = false
proc ToSlash*(path: string): string = path.replace("\\", "/")
proc FromSlash*(path: string): string = path.replace("/", "\\") # Simplified for non-windows
proc SplitList*(path: string): seq[string] = @[path]
proc Split*(path: string): (string, string) = nimos.splitPath(path)
proc Join*(elem: varargs[string]): string = nimos.joinPath(elem)
proc Ext*(path: string): string = nimos.splitFile(path).ext
proc EvalSymlinks*(path: string): (string, goerrors.GoError) = (path, nil)
proc IsAbs*(path: string): bool = nimos.isAbsolute(path)
proc Abs*(path: string): (string, goerrors.GoError) = (nimos.absolutePath(path), nil)
proc Base*(path: string): string = nimos.lastPathPart(path)
proc Dir*(path: string): string = nimos.parentDir(path)
