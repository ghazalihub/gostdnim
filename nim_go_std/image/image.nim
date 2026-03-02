import color/color as gocolor

type
  Image* = concept x
    x.ColorModel() is any
    x.Bounds() is Rectangle
    x.At(int, int) is gocolor.Color

  Rectangle* = object
    Min*, Max*: Point

  Point* = object
    X*, Y*: int

proc Rect*(x0, y0, x1, y1: int): Rectangle =
  Rectangle(Min: Point(X: x0, Y: y0), Max: Point(X: x1, Y: y1))
