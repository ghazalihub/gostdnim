import std/locks
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
    # Nim's locks doesn't have RWLock in all versions/platforms,
    # but let's assume it for now if available, or simulate.
    l: locks.Lock # Simplified to Mutex for now

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

proc initWaitGroup(): WaitGroup =
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

proc initOnce(): Once =
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
