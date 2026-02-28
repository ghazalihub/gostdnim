import std/os as nimos

proc Join*(elem: varargs[string]): string = nimos.joinPath(elem)
proc Base*(path: string): string = nimos.lastPathPart(path)
proc Dir*(path: string): string = nimos.parentDir(path)
proc Ext*(path: string): string = nimos.splitFile(path).ext
proc IsAbs*(path: string): bool = nimos.isAbsolute(path)
