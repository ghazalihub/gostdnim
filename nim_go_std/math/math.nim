import std/math as nimmath

const
  E* = 2.7182818284590452353602874713526624977572470936999595749669676277240766303535
  Pi* = nimmath.PI
  Phi* = 1.61803398874989484820458683436563811772030917980576286213544862270526046281890
  Sqrt2* = 1.4142135623730950488016887242096980785696718753769480731766797379907324784621
  SqrtE* = 1.64872127070012814684865078781416357165377610071014801157507931164066102119421
  SqrtPi* = 1.77245385090551602729816748334114518279754945612238712821380778985291128459103
  SqrtPhi* = 1.27201964951406896425242246173749146771380834211235243062240589716428676454224

  MaxFloat32* = 3.40282346638528859811704183484516925440e+38
  SmallestNonzeroFloat32* = 1.40129846432481707092372958328991613128e-45
  MaxFloat64* = 1.797693134862315708145274237317043567981e+308
  SmallestNonzeroFloat64* = 4.940656458412465441765687928682213723651e-324

proc Abs*(x: float64): float64 = abs(x)
proc Acos*(x: float64): float64 = nimmath.arccos(x)
proc Acosh*(x: float64): float64 = nimmath.arccosh(x)
proc Asin*(x: float64): float64 = nimmath.arcsin(x)
proc Asinh*(x: float64): float64 = nimmath.arcsinh(x)
proc Atan*(x: float64): float64 = nimmath.arctan(x)
proc Atan2*(y, x: float64): float64 = nimmath.arctan2(y, x)
proc Atanh*(x: float64): float64 = nimmath.arctanh(x)
proc Cos*(x: float64): float64 = nimmath.cos(x)
proc Sin*(x: float64): float64 = nimmath.sin(x)
proc Tan*(x: float64): float64 = nimmath.tan(x)
proc Sqrt*(x: float64): float64 = nimmath.sqrt(x)
proc Pow*(x, y: float64): float64 = nimmath.pow(x, y)
proc Log*(x: float64): float64 = nimmath.ln(x)
proc Log10*(x: float64): float64 = nimmath.log10(x)
proc Log2*(x: float64): float64 = nimmath.log2(x)
proc Exp*(x: float64): float64 = nimmath.exp(x)
proc Floor*(x: float64): float64 = nimmath.floor(x)
proc Ceil*(x: float64): float64 = nimmath.ceil(x)
proc Trunc*(x: float64): float64 = nimmath.trunc(x)
proc Round*(x: float64): float64 = nimmath.round(x)
proc Max*(x, y: float64): float64 = max(x, y)
proc Min*(x, y: float64): float64 = min(x, y)

proc IsNaN*(f: float64): bool = nimmath.classify(f) == fcNaN
proc NaN*(): float64 = system.NaN
proc Inf*(sign: int): float64 =
  if sign >= 0: system.Inf
  else: -system.Inf

proc IsInf*(f: float64, sign: int): bool =
  let c = nimmath.classify(f)
  if sign > 0: c == fcInf
  elif sign < 0: c == fcNegInf
  else: c == fcInf or c == fcNegInf

proc Copysign*(f, sign: float64): float64 = nimmath.copysign(f, sign)
proc Dim*(x, y: float64): float64 =
  let v = x - y
  if v <= 0: 0.0 else: v

proc Erf*(x: float64): float64 = nimmath.erf(x)
proc Erfc*(x: float64): float64 = nimmath.erfc(x)

proc Cbrt*(x: float64): float64 = nimmath.cbrt(x)
proc Exp2*(x: float64): float64 = nimmath.pow(2.0, x)
proc Expm1*(x: float64): float64 = nimmath.exp(x) - 1.0 # Simplified
proc Hypot*(p, q: float64): float64 = nimmath.hypot(p, q)
proc Mod*(x, y: float64): float64 = nimmath.floorMod(x, y)
proc Signbit*(x: float64): bool =
  let c = nimmath.classify(x)
  return c == fcNegInf or c == fcNegZero or (x < 0.0)

proc Sincos*(x: float64): (float64, float64) = (nimmath.sin(x), nimmath.cos(x))
proc Sinh*(x: float64): float64 = nimmath.sinh(x)
proc Cosh*(x: float64): float64 = nimmath.cosh(x)
proc Tanh*(x: float64): float64 = nimmath.tanh(x)
