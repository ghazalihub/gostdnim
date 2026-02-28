type
  Element* = ref object
    Value*: any
    next, prev: Element
    list: List

  List* = ref object
    root: Element
    len: int

proc New*(): List =
  let l = List()
  l.root = Element()
  l.root.next = l.root
  l.root.prev = l.root
  l.len = 0
  return l

proc Len*(l: List): int = l.len
proc Front*(l: List): Element = l.root.next
proc Back*(l: List): Element = l.root.prev

proc PushFront*(l: List, v: any): Element = discard
proc PushBack*(l: List, v: any): Element = discard
