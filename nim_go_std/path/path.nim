import std/os as nimos

proc Clean*(path: string): string = nimos.normalizedPath(path)
proc Split*(path: string): (string, string) = nimos.splitPath(path)
proc Join*(elem: varargs[string]): string = nimos.joinPath(elem)
proc Ext*(path: string): string = nimos.splitFile(path).ext
proc Base*(path: string): string = nimos.lastPathPart(path)
proc IsAbs*(path: string): bool = nimos.isAbsolute(path)
proc Dir*(path: string): string = nimos.parentDir(path)
