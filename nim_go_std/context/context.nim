import ../time/time as gotime
import ../errors/errors as goerrors

type
  Context* = concept x
    x.Done() is bool
    x.Err() is goerrors.GoError

  CancelFunc* = proc()

type
  BaseContext* = ref object
    done: bool
    err: goerrors.GoError

proc Done*(c: BaseContext): bool = c.done
proc Err*(c: BaseContext): goerrors.GoError = c.err
proc Value*(c: BaseContext, key: any): any = nil

proc Background*(): BaseContext = BaseContext(done: false, err: nil)
proc TODO*(): BaseContext = BaseContext(done: false, err: nil)

proc WithCancel*(parent: Context): (BaseContext, CancelFunc) =
  let ctx = BaseContext(done: false, err: nil)
  let cancel = proc() =
    ctx.done = true
    ctx.err = goerrors.New("context canceled")
  return (ctx, cancel)

proc WithTimeout*(parent: Context, timeout: gotime.Duration): (BaseContext, CancelFunc) =
  return WithCancel(parent)
