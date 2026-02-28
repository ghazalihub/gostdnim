import std/osproc

proc GOMAXPROCS*(n: int): int =
  # Simplified: Nim handles threads differently, but we can return something plausible
  return countProcessors()

proc NumCPU*(): int =
  return countProcessors()

proc Gosched*() =
  # Yield execution
  discard

proc Goexit*() =
  # Terminate current thread (simplified)
  quit(0)

proc GC*() =
  GC_fullCollect()

proc NumGoroutine*(): int = 1
