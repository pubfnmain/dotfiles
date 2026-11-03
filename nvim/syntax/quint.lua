-- Quint syntax, ported from quint-co/quint editor-plugins/vim/quint.vim
if vim.b.current_syntax then
  return
end

local function syn(...)
  vim.cmd.syntax({ args = { ... } })
end

syn('clear')

-- operators/delimiters first: on same-position ties last-defined wins,
-- so comments and negative numbers must come after
syn('match', 'quintOper', [["<-\|<=\|>=\|==\|!=\|=>\|->\|[\^+*/%.<>-]"]])
syn('match', 'quintDelim', [["[,:;]"]])

-- comments
syn('match', 'quintComment', [["//.*$"]])
syn('region', 'quintComment', [[start="/\*"]], [[end="\*/"]], 'fold')

-- identifiers
syn('match', 'quintIdent', [["[a-zA-Z_][a-zA-Z0-9_]*"]])

-- numbers and strings
syn('match', 'quintNumber', [['-\?\(0x[0-9a-fA-F]\([0-9a-fA-F]\|_[0-9a-fA-F]\)*\|0\|[1-9]\([0-9]\|_[0-9]\)*\)']])
syn('region', 'quintString', [[start='"']], [[end='"']])

-- types
syn('keyword', 'quintType', 'int', 'str', 'bool', 'Set', 'List', 'Rec', 'Tup')

-- typedefs
syn('keyword', 'quintTypedef', 'type')

-- built-in values
syn('keyword', 'quintValue', 'Bool', 'Int', 'Nat')
syn('keyword', 'quintBoolValue', 'false', 'true')

-- conditionals
syn('keyword', 'quintCond', 'if', 'else')

-- declarations
syn('keyword', 'quintDecl', 'module', 'import', 'from', 'export', 'const', 'var', 'val', 'def',
  'pure', 'nondet', 'action', 'temporal', 'assume', 'run')

-- standard operators
syn('keyword', 'quintStd', 'Set', 'List', 'Map', 'Rec', 'Tup')
syn('keyword', 'quintStd', 'not', 'and', 'or', 'iff', 'implies', 'all', 'any', 'as', 'leadsTo')

-- curly braces
syn('region', 'quintBlock', 'start="{"', 'end="}"', 'fold', 'transparent', 'contains=ALLBUT,quintCurlyError')
syn('match', 'quintCurlyError', '"}"')

-- parentheses
syn('region', 'quintParen', 'start="("', 'end=")"', 'fold', 'transparent', 'contains=ALLBUT,quintParenError')
syn('match', 'quintParenError', '")"')

-- braces
syn('region', 'quintBrace', [[start="\["]], [[end="\]"]], 'fold', 'transparent', 'contains=ALLBUT,quintBraceError')
syn('match', 'quintBraceError', [["\]"]])

local links = {
  quintComment = 'Comment',
  quintIdent = 'Identifier',
  quintType = 'Type',
  quintTypedef = 'Typedef',
  quintString = 'String',
  quintNumber = 'Number',
  quintBoolValue = 'Boolean',
  quintValue = 'Constant',
  quintDecl = 'StorageClass',
  quintStd = 'Statement',
  quintOper = 'Operator',
  quintCond = 'Conditional',
  quintParenError = 'Error',
  quintBraceError = 'Error',
  quintCurlyError = 'Error',
}
for group, target in pairs(links) do
  vim.api.nvim_set_hl(0, group, { link = target, default = true })
end

vim.b.current_syntax = 'quint'
