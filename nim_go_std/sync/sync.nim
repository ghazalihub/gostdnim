import std/[locks, tables]
import ../errors/errors as goerrors

type
  Locker* = concept x
    x.Lock()
    x.Unlock()

  Mutex* = object
    l: locks.Lock

proc initMutex(): Mutex =
  result.l.initLock()

proc Lock*(m: var Mutex) = m.l.acquire()
proc Unlock*(m: var Mutex) = m.l.release()

type
  RWMutex* = object
    l: locks.Lock # Simplified

proc initRWMutex(): RWMutex =
  result.l.initLock()

proc Lock*(m: var RWMutex) = m.l.acquire()
proc Unlock*(m: var RWMutex) = m.l.release()
proc RLock*(m: var RWMutex) = m.l.acquire()
proc RUnlock*(m: var RWMutex) = m.l.release()

type
  WaitGroup* = ref object
    count: int
    cond: locks.Cond
    l: locks.Lock

proc NewWaitGroup*(): WaitGroup =
  var wg = WaitGroup()
  wg.cond.initCond()
  wg.l.initLock()
  wg.count = 0
  return wg

proc Add*(wg: WaitGroup, delta: int) =
  wg.l.acquire()
  wg.count += delta
  if wg.count < 0: raise newException(Exception, "sync: negative WaitGroup counter")
  if wg.count == 0: wg.cond.broadcast()
  wg.l.release()

proc Done*(wg: WaitGroup) = wg.Add(-1)

proc Wait*(wg: WaitGroup) =
  wg.l.acquire()
  while wg.count > 0:
    wg.cond.wait(wg.l)
  wg.l.release()

type
  Once* = ref object
    done: bool
    l: locks.Lock

proc NewOnce*(): Once =
  var o = Once()
  o.l.initLock()
  o.done = false
  return o

proc Do*(o: Once, f: proc()) =
  if o.done: return
  o.l.acquire()
  if not o.done:
    f()
    o.done = true
  o.l.release()

type
  Cond* = ref object
    L*: Locker
    c: locks.Cond

proc NewCond*(l: Locker): Cond =
  var c = Cond(L: l)
  c.c.initCond()
  return c

proc Wait*(c: Cond) = discard

proc Signal*(c: Cond) = c.c.signal()
proc Broadcast*(c: Cond) = c.c.broadcast()

type
  Map* = ref object
    l: locks.Lock
    m: Table[string, RootRef] # Use RootRef for generic values

proc NewMap*(): Map =
  var m = Map()
  m.l.initLock()
  m.m = initTable[string, RootRef]()
  return m

proc Load*(m: Map, key: string): (RootRef, bool) =
  m.l.acquire()
  defer: m.l.release()
  if key in m.m: return (m.m[key], true)
  return (nil, false)

proc Store*(m: Map, key: string, value: RootRef) =
  m.l.acquire()
  defer: m.l.release()
  m.m[key] = value

proc Delete*(m: Map, key: string) =
  m.l.acquire()
  defer: m.l.release()
  m.m.del(key)

proc Range*(m: Map, f: proc(key: string, value: RootRef): bool) =
  m.l.acquire()
  defer: m.l.release()
  for k, v in m.m:
    if not f(k, v): break

type
  Pool* = ref object
    New*: proc(): RootRef
