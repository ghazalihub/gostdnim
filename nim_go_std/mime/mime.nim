import ../errors/errors as goerrors

proc TypeByExtension*(ext: string): string = ""
proc ExtensionsByType*(typ: string): (seq[string], goerrors.GoError) = (@[], nil)
