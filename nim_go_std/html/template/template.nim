import ../html as gohtml

type
  Template* = ref object

proc New*(name: string): Template = Template()
proc Parse*(t: Template, src: string): (Template, ref Exception) = (t, nil)
proc Execute*(t: Template, wr: any, data: any): ref Exception = nil
