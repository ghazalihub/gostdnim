type
  Color* = concept x
    x.RGBA() is (uint32, uint32, uint32, uint32)

  RGBAObj* = object
    R*, G*, B*, A*: uint8

proc RGBA*(c: RGBAObj): (uint32, uint32, uint32, uint32) =
  return (uint32(c.R), uint32(c.G), uint32(c.B), uint32(c.A))

var Black* = RGBAObj(R: 0, G: 0, B: 0, A: 255)
var White* = RGBAObj(R: 255, G: 255, B: 255, A: 255)
