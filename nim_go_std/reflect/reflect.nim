import std/typetraits

proc TypeOf*(i: any): string =
  return i.type.name

proc DeepEqual*(x, y: any): bool =
  return x == y
