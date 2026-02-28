type
  Element*[T] = ref object
    next, prev: Element[T]
    list: List[T]
    Value*: T

  List*[T] = ref object
    root: Element[T]
    len: int

proc Init*[T](l: List[T]): List[T] =
  l.root = Element[T]()
  l.root.next = l.root
  l.root.prev = l.root
  l.len = 0
  return l

proc New*[T](): List[T] =
  var l = List[T]()
  return l.Init()

proc Len*[T](l: List[T]): int = l.len

proc Front*[T](l: List[T]): Element[T] =
  if l.len == 0: return nil
  return l.root.next

proc Back*[T](l: List[T]): Element[T] =
  if l.len == 0: return nil
  return l.root.prev

proc lazyInit[T](l: List[T]) =
  if l.root == nil: discard l.Init()
  elif l.root.next == nil: discard l.Init()

proc insert[T](l: List[T], e, at: Element[T]): Element[T] =
  e.prev = at
  e.next = at.next
  e.prev.next = e
  e.next.prev = e
  e.list = l
  l.len += 1
  return e

proc insertValue[T](l: List[T], v: T, at: Element[T]): Element[T] =
  return l.insert(Element[T](Value: v), at)

proc remove[T](l: List[T], e: Element[T]) =
  e.prev.next = e.next
  e.next.prev = e.prev
  e.next = nil
  e.prev = nil
  e.list = nil
  l.len -= 1

proc move[T](l: List[T], e, at: Element[T]) =
  if e == at: return
  e.prev.next = e.next
  e.next.prev = e.prev
  e.prev = at
  e.next = at.next
  e.prev.next = e
  e.next.prev = e

proc Remove*[T](l: List[T], e: Element[T]): T =
  if e.list == l:
    l.remove(e)
  return e.Value

proc PushFront*[T](l: List[T], v: T): Element[T] =
  l.lazyInit()
  return l.insertValue(v, l.root)

proc PushBack*[T](l: List[T], v: T): Element[T] =
  l.lazyInit()
  return l.insertValue(v, l.root.prev)

proc InsertBefore*[T](l: List[T], v: T, mark: Element[T]): Element[T] =
  if mark.list != l: return nil
  return l.insertValue(v, mark.prev)

proc InsertAfter*[T](l: List[T], v: T, mark: Element[T]): Element[T] =
  if mark.list != l: return nil
  return l.insertValue(v, mark)

proc MoveToFront*[T](l: List[T], e: Element[T]) =
  if e.list != l or l.root.next == e: return
  l.remove(e)
  discard l.insert(e, l.root)

proc MoveToBack*[T](l: List[T], e: Element[T]) =
  if e.list != l or l.root.prev == e: return
  l.remove(e)
  discard l.insert(e, l.root.prev)

proc MoveBefore*[T](l: List[T], e, mark: Element[T]) =
  if e.list != l or e == mark or mark.list != l: return
  l.remove(e)
  discard l.insert(e, mark.prev)

proc MoveAfter*[T](l: List[T], e, mark: Element[T]) =
  if e.list != l or e == mark or mark.list != l: return
  l.remove(e)
  discard l.insert(e, mark)

proc PushBackList*[T](l, other: List[T]) =
  l.lazyInit()
  var e = other.Front()
  var i = other.Len()
  while i > 0:
    discard l.insertValue(e.Value, l.root.prev)
    e = e.next
    i -= 1

proc PushFrontList*[T](l, other: List[T]) =
  l.lazyInit()
  var e = other.Back()
  var i = other.Len()
  while i > 0:
    discard l.insertValue(e.Value, l.root)
    e = e.prev
    i -= 1

proc Next*[T](e: Element[T]): Element[T] =
  if e.list != nil and e.next != e.list.root:
    return e.next
  return nil

proc Prev*[T](e: Element[T]): Element[T] =
  if e.list != nil and e.prev != e.list.root:
    return e.prev
  return nil
