import std/algorithm

type
  Interface* = concept x
    x.Len() is int
    x.Less(int, int) is bool
    x.Swap(int, int)
    x.Push(auto)
    x.Pop() is auto

proc Init*(h: Interface) = discard
proc Push*(h: Interface, x: any) = h.Push(x)
proc Pop*(h: Interface): any = h.Pop()
proc Remove*(h: Interface, i: int): any = discard
proc Fix*(h: Interface, i: int) = discard
