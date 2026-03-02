import ../../io/io as goio
import ../../errors/errors as goerrors

type
  Template* = ref object
    name: string

proc New*(name: string): Template = Template(name: name)

proc Parse*(t: Template, src: string): (Template, goerrors.GoError) = (t, nil)

proc Execute*(t: Template, wr: var goio.Writer, data: any): goerrors.GoError = nil

proc Must*(t: Template, err: goerrors.GoError): Template =
  if err != nil: raise newException(Exception, err.msg)
  return t
