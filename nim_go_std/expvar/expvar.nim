type
  Var* = concept x
    x.String() is string

  Int* = ref object
    val: int

proc (v: Int) String(): string = $v.val
proc (v: Int) Add*(delta: int) = v.val += delta
proc (v: Int) Set*(value: int) = v.val = value

proc NewInt*(name: string): Int = Int(val: 0)

proc Publish*(name: string, v: Var) = discard
