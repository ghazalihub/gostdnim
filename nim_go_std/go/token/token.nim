type
  Token* = int

proc Lookup*(ident: string): Token = 0
proc IsExported*(name: string): bool =
  if name.len == 0: return false
  return name[0] in {'A'..'Z'}

proc IsKeyword*(name: string): bool = false
proc IsIdentifier*(name: string): bool = true

type
  FileSet* = ref object

proc NewFileSet*(): FileSet = FileSet()
