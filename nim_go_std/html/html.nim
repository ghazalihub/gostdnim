import std/[xmltree, strutils]

proc EscapeString*(s: string): string =
  xmltree.escape(s)

proc UnescapeString*(s: string): string =
  s.replace("&lt;", "<").replace("&gt;", ">").replace("&amp;", "&").replace("&quot;", "\"").replace("&#39;", "'")
