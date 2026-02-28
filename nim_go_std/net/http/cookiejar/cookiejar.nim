import ../url/url as gourl

type
  Jar* = concept x
    x.SetCookies(u: gourl.URL, cookies: seq[any])
    x.Cookies(u: gourl.URL) is seq[any]

  Options* = object
    PublicSuffixList*: any

  JarImpl = ref object

proc New*(o: ptr Options): (JarImpl, ref Exception) =
  return (JarImpl(), nil)

proc SetCookies*(j: JarImpl, u: gourl.URL, cookies: seq[any]) = discard
proc Cookies*(j: JarImpl, u: gourl.URL): seq[any] = @[]
