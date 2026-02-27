type
  GoError* = ref object
    msg*: string

proc Error*(e: GoError): string =
  if e == nil: return ""
  return e.msg

proc `$`*(e: GoError): string = Error(e)

proc New*(msg: string): GoError =
  GoError(msg: msg)
