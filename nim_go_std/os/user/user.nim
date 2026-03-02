import ../../errors/errors as goerrors
import std/os

type
  User* = ref object
    Uid*: string
    Gid*: string
    Username*: string
    Name*: string
    HomeDir*: string

proc Current*(): (User, goerrors.GoError) =
  return (User(Uid: "0", Gid: "0", Username: "root", Name: "root", HomeDir: "/root"), nil)

proc Lookup*(username: string): (User, goerrors.GoError) =
  return (nil, goerrors.New("not implemented"))
