import nim_go_std/io/io as goio
import nim_go_std/fmt/fmt as gofmt
import nim_go_std/bufio/bufio as gobufio
import nim_go_std/os/os as goos
import nim_go_std/log/log as golog
import nim_go_std/flag/flag as goflag
import nim_go_std/time/time as gotime
import nim_go_std/regexp/regexp as goregexp
import nim_go_std/strconv/strconv as gostrconv
import std/unicode as nunicode

# Comprehensive Test Suite for extended packages

# io
# Need a concrete implementation of Reader/Writer for testing
type StringReader = object
  s: string
  pos: int
proc Read(r: var StringReader, p: var seq[byte]): (int, gostrconv.GoError) =
  if r.pos >= r.s.len: return (0, gostrconv.GoError(msg: "EOF"))
  let n = min(p.len, r.s.len - r.pos)
  for i in 0 ..< n: p[i] = byte(r.s[r.pos + i])
  r.pos += n
  return (n, nil)

var sr = StringReader(s: "hello world", pos: 0)
let (content, err) = goio.ReadAll(sr)
assert err == nil
assert cast[string](content) == "hello world"

# fmt
assert gofmt.Sprintf("hello %v", "world") == "hello world"
assert gofmt.Sprint("foo", "bar") == "foobar"

# os
let envKey = "TEST_NIM_GO_STD"
discard goos.Setenv(envKey, "123")
assert goos.Getenv(envKey) == "123"

# time
let now = gotime.Now()
gotime.Sleep(10 * gotime.Millisecond)
assert gotime.Since(now) >= 10 * gotime.Millisecond

# regexp
let re = goregexp.MustCompile("a.b")
assert re.MatchString("axb")
assert not re.MatchString("abc")

# flag
discard goflag.String("test", "default", "usage")
goflag.Parse()
assert goflag.Parsed()

# log
golog.Print("Log test")

echo "Extended comprehensive tests passed!"
