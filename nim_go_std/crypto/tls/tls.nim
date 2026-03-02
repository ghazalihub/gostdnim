import ../../errors/errors as goerrors
import ../../net/net as gonet

type
  Config* = ref object
    InsecureSkipVerify*: bool

proc Dial*(network, addr_str: string, config: Config): (gonet.Conn, goerrors.GoError) =
  return gonet.Dial(network, addr_str)

proc Listen*(network, laddr: string, config: Config): (gonet.Listener, goerrors.GoError) =
  # Simplified
  return (nil, nil)
