-- 'opencode' colorscheme: a port of OpenCode's default TUI theme (dark variant)
-- to native Neovim highlight groups.
--
-- Palette source:
-- https://github.com/sst/opencode/blob/dev/packages/tui/src/theme/assets/opencode.json
-- Roles: syntaxComment -> muted, syntaxKeyword -> accent (purple), syntaxFunction -> primary
-- (orange), syntaxVariable -> error (red), syntaxString -> success (green), syntaxNumber ->
-- warning, syntaxType -> yellow, syntaxOperator -> info (cyan), syntaxPunctuation -> text.
local M = {}

local palette = {
  -- grayscale steps
  step1 = '#0a0a0a', -- background
  step2 = '#141414', -- backgroundPanel
  step3 = '#1e1e1e', -- backgroundElement
  step4 = '#282828',
  step5 = '#323232',
  step6 = '#3c3c3c', -- borderSubtle
  step7 = '#484848', -- border
  step8 = '#606060', -- borderActive
  -- text
  fg = '#eeeeee',
  muted = '#808080', -- textMuted / comments
  -- accent colors
  orange = '#fab283', -- primary / functions
  blue = '#5c9cf5', -- secondary
  purple = '#9d7cd8', -- accent / keywords
  red = '#e06c75', -- error / variables
  warn = '#f5a742', -- warning / numbers
  green = '#7fd88f', -- success / strings
  cyan = '#56b6c2', -- info / operators
  yellow = '#e5c07b', -- types
  -- diff
  diff_add = '#4fd6be',
  diff_remove = '#c53b53',
  diff_context = '#828bb8',
  diff_add_hl = '#b8db87',
  diff_remove_hl = '#e26a75',
  diff_add_bg = '#20303b',
  diff_remove_bg = '#37222c',
}

function M.setup()
  local p = palette

  vim.o.background = 'dark'
  vim.g.colors_name = 'opencode'

  -- terminal palette (so :terminal matches)
  vim.g.terminal_color_0 = p.step1
  vim.g.terminal_color_1 = p.red
  vim.g.terminal_color_2 = p.green
  vim.g.terminal_color_3 = p.yellow
  vim.g.terminal_color_4 = p.blue
  vim.g.terminal_color_5 = p.purple
  vim.g.terminal_color_6 = p.cyan
  vim.g.terminal_color_7 = p.muted
  vim.g.terminal_color_8 = p.step7
  vim.g.terminal_color_9 = p.red
  vim.g.terminal_color_10 = p.green
  vim.g.terminal_color_11 = p.warn
  vim.g.terminal_color_12 = p.blue
  vim.g.terminal_color_13 = p.purple
  vim.g.terminal_color_14 = p.cyan
  vim.g.terminal_color_15 = p.fg

  local groups = {
    -- editor UI
    Normal = { fg = p.fg, bg = p.step1 },
    NormalNC = { fg = p.fg, bg = p.step1 },
    NormalFloat = { fg = p.fg, bg = p.step2 },
    FloatBorder = { fg = p.step8, bg = p.step2 },
    FloatTitle = { fg = p.orange, bold = true },
    Cursor = { fg = p.step1, bg = p.orange },
    CursorIM = { fg = p.step1, bg = p.orange },
    TermCursor = { fg = p.step1, bg = p.orange },
    TermCursorNC = { fg = p.step1, bg = p.step7 },
    CursorLine = { bg = p.step3 },
    CursorColumn = { bg = p.step3 },
    ColorColumn = { bg = p.step2 },
    LineNr = { fg = p.step7 },
    LineNrAbove = { fg = p.step7 },
    LineNrBelow = { fg = p.step7 },
    CursorLineNr = { fg = p.orange, bold = true },
    SignColumn = { bg = p.step1 },
    Folded = { fg = p.muted, bg = p.step2 },
    FoldColumn = { fg = p.step7 },
    WinSeparator = { fg = p.step7 },
    WinBar = { fg = p.fg, bg = p.step2 },
    WinBarNC = { fg = p.muted, bg = p.step2 },
    StatusLine = { fg = p.fg, bg = p.step2 },
    StatusLineNC = { fg = p.step7, bg = p.step2 },
    TabLine = { fg = p.muted, bg = p.step2 },
    TabLineSel = { fg = p.fg, bg = p.step1, bold = true },
    TabLineFill = { fg = p.step7, bg = p.step2 },
    Visual = { bg = p.step4 },
    VisualNOS = { bg = p.step4 },
    Search = { fg = p.step1, bg = p.orange },
    CurSearch = { fg = p.step1, bg = p.yellow, bold = true },
    IncSearch = { fg = p.step1, bg = p.yellow, bold = true },
    Substitute = { fg = p.step1, bg = p.red },
    MatchParen = { fg = p.yellow, bold = true },
    Directory = { fg = p.blue },
    Title = { fg = p.orange, bold = true },
    ErrorMsg = { fg = p.red, bold = true },
    WarningMsg = { fg = p.warn },
    MoreMsg = { fg = p.muted },
    ModeMsg = { fg = p.muted },
    Question = { fg = p.green },
    QuickFixLine = { bg = p.step4 },
    qfLineNr = { fg = p.muted },
    qfSeparator = { fg = p.step7 },
    Pmenu = { fg = p.fg, bg = p.step2 },
    PmenuSel = { fg = p.step1, bg = p.orange },
    PmenuSbar = { bg = p.step3 },
    PmenuThumb = { bg = p.step7 },
    WildMenu = { fg = p.orange, bold = true },
    SpellBad = { fg = p.red, undercurl = true, sp = p.red },
    SpellCap = { fg = p.blue, undercurl = true, sp = p.blue },
    SpellLocal = { fg = p.cyan, undercurl = true, sp = p.cyan },
    SpellRare = { fg = p.purple, undercurl = true, sp = p.purple },
    EndOfBuffer = { fg = p.step6 },
    NonText = { fg = p.step7 },
    Whitespace = { fg = p.step6 },
    Conceal = { fg = p.step8 },

    -- legacy syntax (fallback when no Treesitter)
    Comment = { fg = p.muted },
    Constant = { fg = p.warn },
    String = { fg = p.green },
    Character = { fg = p.green },
    Number = { fg = p.warn },
    Boolean = { fg = p.warn },
    Float = { fg = p.warn },
    Identifier = { fg = p.red },
    Function = { fg = p.orange },
    Statement = { fg = p.purple },
    Conditional = { fg = p.purple },
    Repeat = { fg = p.purple },
    Label = { fg = p.purple },
    Operator = { fg = p.cyan },
    Keyword = { fg = p.purple },
    Exception = { fg = p.red },
    PreProc = { fg = p.purple },
    Include = { fg = p.purple },
    Define = { fg = p.purple },
    Macro = { fg = p.purple },
    PreCondit = { fg = p.purple },
    Type = { fg = p.yellow },
    StorageClass = { fg = p.yellow },
    Structure = { fg = p.yellow },
    Typedef = { fg = p.yellow },
    Special = { fg = p.cyan },
    SpecialChar = { fg = p.cyan },
    Tag = { fg = p.blue },
    Delimiter = { fg = p.fg },
    SpecialComment = { fg = p.muted },
    Debug = { fg = p.warn },
    Underlined = { fg = p.blue, underline = true },
    Error = { fg = p.red, bold = true },
    Todo = { fg = p.warn, bold = true },

    -- Treesitter
    ['@comment'] = { fg = p.muted },
    ['@keyword'] = { fg = p.purple },
    ['@function'] = { fg = p.orange },
    ['@variable'] = { fg = p.red },
    ['@constant'] = { fg = p.warn },
    ['@constant.builtin'] = { fg = p.cyan },
    ['@constant.macro'] = { fg = p.purple },
    ['@string'] = { fg = p.green },
    ['@string.escape'] = { fg = p.cyan },
    ['@string.regexp'] = { fg = p.cyan },
    ['@number'] = { fg = p.warn },
    ['@type'] = { fg = p.yellow },
    ['@operator'] = { fg = p.cyan },
    ['@property'] = { fg = p.blue },
    ['@attribute'] = { fg = p.cyan },
    ['@label'] = { fg = p.blue },
    ['@namespace'] = { fg = p.cyan },
    ['@symbol'] = { fg = p.cyan },
    ['@punctuation.delimiter'] = { fg = p.fg },
    ['@punctuation.bracket'] = { fg = p.fg },
    ['@punctuation.special'] = { fg = p.cyan },
    ['@variable.builtin'] = { fg = p.purple },
    ['@tag'] = { fg = p.cyan },
    ['@tag.delimiter'] = { fg = p.muted },
    ['@markup.heading'] = { fg = p.purple, bold = true },
    ['@markup.link'] = { fg = p.cyan },
    ['@markup.link.url'] = { fg = p.blue, underline = true },
    ['@markup.list'] = { fg = p.orange },
    ['@markup.list.checked'] = { fg = p.green },
    ['@markup.list.unchecked'] = { fg = p.warn },
    ['@markup.raw'] = { fg = p.green },
    ['@markup.raw.block'] = { fg = p.fg },
    ['@markup.italic'] = { fg = p.yellow, italic = true },
    ['@markup.strong'] = { fg = p.warn, bold = true },
    ['@markup.strikethrough'] = { fg = p.muted, strikethrough = true },
    ['@markup.underline'] = { fg = p.cyan, underline = true },
    ['@markup.quote'] = { fg = p.yellow },
    ['@markup.math'] = { fg = p.cyan },
    ['@diff.plus'] = { fg = p.diff_add },
    ['@diff.minus'] = { fg = p.diff_remove },
    ['@diff.delta'] = { fg = p.diff_context },

    -- diagnostics
    DiagnosticError = { fg = p.red },
    DiagnosticWarn = { fg = p.warn },
    DiagnosticInfo = { fg = p.cyan },
    DiagnosticHint = { fg = p.blue },
    DiagnosticOk = { fg = p.green },
    DiagnosticSignError = { fg = p.red },
    DiagnosticSignWarn = { fg = p.warn },
    DiagnosticSignInfo = { fg = p.cyan },
    DiagnosticSignHint = { fg = p.blue },
    DiagnosticUnderlineError = { undercurl = true, sp = p.red },
    DiagnosticUnderlineWarn = { undercurl = true, sp = p.warn },
    DiagnosticUnderlineInfo = { undercurl = true, sp = p.cyan },
    DiagnosticUnderlineHint = { undercurl = true, sp = p.blue },
    DiagnosticVirtualTextError = { fg = p.red, bg = p.step2 },
    DiagnosticVirtualTextWarn = { fg = p.warn, bg = p.step2 },
    DiagnosticVirtualTextInfo = { fg = p.cyan, bg = p.step2 },
    DiagnosticVirtualTextHint = { fg = p.blue, bg = p.step2 },
    DiagnosticFloatingError = { fg = p.red, bg = p.step2 },
    DiagnosticFloatingWarn = { fg = p.warn, bg = p.step2 },
    DiagnosticFloatingInfo = { fg = p.cyan, bg = p.step2 },
    DiagnosticFloatingHint = { fg = p.blue, bg = p.step2 },
    LspReferenceText = { bg = p.step4 },
    LspReferenceRead = { bg = p.step4 },
    LspReferenceWrite = { bg = p.step4 },

    -- diff / git
    DiffAdd = { fg = p.diff_add_hl, bg = p.diff_add_bg },
    DiffChange = { bg = p.step2 },
    DiffText = { fg = p.diff_add_hl, bg = p.step4 },
    DiffDelete = { fg = p.diff_remove_hl, bg = p.diff_remove_bg },
    Added = { fg = p.diff_add },
    Removed = { fg = p.diff_remove },
    Changed = { fg = p.diff_context },
    GitSignsAdd = { fg = p.diff_add },
    GitSignsChange = { fg = p.diff_context },
    GitSignsDelete = { fg = p.diff_remove },
    GitSignsTopdelete = { fg = p.diff_remove },
    GitSignsChangedelete = { fg = p.warn },
    GitSignsUntracked = { fg = p.blue },
    GitSignsAddLn = { fg = p.step1, bg = p.diff_add },
    GitSignsChangeLn = { bg = p.step4 },
    GitSignsDeleteLn = { fg = p.step1, bg = p.diff_remove },
    DiffviewDiffAdd = { bg = p.diff_add_bg },
    DiffviewDiffChange = { bg = p.step2 },
    DiffviewDiffText = { bg = p.step4 },
    DiffviewDiffDelete = { bg = p.diff_remove_bg },
    DiffviewFilePanelTitle = { fg = p.orange, bold = true },
    DiffviewFilePanelCounter = { fg = p.muted },
    DiffviewFilePanelFileName = { fg = p.fg },
    DiffviewFolderName = { fg = p.blue },
    DiffviewReference = { fg = p.cyan },
    DiffviewDim1 = { fg = p.step7 },

    -- telescope
    TelescopeNormal = { fg = p.fg, bg = p.step1 },
    TelescopeBorder = { fg = p.step7, bg = p.step1 },
    TelescopeTitle = { fg = p.step1, bg = p.orange, bold = true },
    TelescopeSelection = { fg = p.fg, bg = p.step4 },
    TelescopeSelectionCaret = { fg = p.orange, bold = true },
    TelescopeMatching = { fg = p.yellow, bold = true },
    TelescopePromptPrefix = { fg = p.orange },
    TelescopeMultiSelection = { fg = p.blue },
    TelescopeResultsDiffAdd = { fg = p.diff_add },
    TelescopeResultsDiffChange = { fg = p.cyan },
    TelescopeResultsDiffDelete = { fg = p.diff_remove },
    TelescopePreviewHyperlink = { fg = p.blue, underline = true },
    TelescopePreviewLine = { bg = p.step3 },
    TelescopePreviewMatch = { fg = p.step1, bg = p.orange },

    -- nvim-tree
    NvimTreeNormal = { fg = p.fg, bg = p.step1 },
    NvimTreeNormalNC = { fg = p.fg, bg = p.step1 },
    NvimTreeRootFolder = { fg = p.orange, bold = true },
    NvimTreeFolderIcon = { fg = p.blue },
    NvimTreeFolderName = { fg = p.blue },
    NvimTreeOpenedFolderName = { fg = p.blue, bold = true },
    NvimTreeEmptyFolderName = { fg = p.muted },
    NvimTreeIndentMarker = { fg = p.step7 },
    NvimTreeSymlink = { fg = p.cyan },
    NvimTreeSpecialFile = { fg = p.yellow },
    NvimTreeImageFile = { fg = p.warn },
    NvimTreeGitDirty = { fg = p.warn },
    NvimTreeGitNew = { fg = p.diff_add },
    NvimTreeGitDeleted = { fg = p.diff_remove },
    NvimTreeGitIgnored = { fg = p.step7 },
    NvimTreeWinSeparator = { fg = p.step7 },

    -- which-key
    WhichKey = { fg = p.orange },
    WhichKeyGroup = { fg = p.purple },
    WhichKeyDesc = { fg = p.fg },
    WhichKeySeparator = { fg = p.step7 },
    WhichKeyFloat = { bg = p.step2 },
    WhichKeyBorder = { fg = p.step7 },
    WhichKeyValue = { fg = p.muted },

    -- mini.statusline (used instead of lualine)
    MiniStatuslineModeNormal = { fg = p.step1, bg = p.blue, bold = true },
    MiniStatuslineModeInsert = { fg = p.step1, bg = p.green, bold = true },
    MiniStatuslineModeVisual = { fg = p.step1, bg = p.purple, bold = true },
    MiniStatuslineModeReplace = { fg = p.step1, bg = p.red, bold = true },
    MiniStatuslineModeCommand = { fg = p.step1, bg = p.warn, bold = true },
    MiniStatuslineModeOther = { fg = p.step1, bg = p.cyan, bold = true },
    MiniStatuslineInactive = { fg = p.step7, bg = p.step2 },
    MiniStatuslineFilename = { fg = p.muted, bg = p.step2 },
    MiniStatuslineFileinfo = { fg = p.fg, bg = p.step2 },
    MiniStatuslineDevinfo = { fg = p.fg, bg = p.step2 },

    -- obsidian.nvim
    ObsidianTodo = { fg = p.warn, bold = true },
    ObsidianDone = { fg = p.green, bold = true },
    ObsidianTaskDone = { fg = p.muted },
    ObsidianHighlightText = { bg = p.step5 },
    ObsidianTag = { fg = p.cyan },
    ObsidianRefLink = { fg = p.blue, underline = true },
    ObsidianBullet = { fg = p.orange },
    ObsidianBlockquote = { fg = p.yellow },
  }

  local links = {
    -- treesitter subgroups -> base groups
    ['@comment.documentation'] = '@comment',
    ['@keyword.conditional'] = '@keyword',
    ['@keyword.repeat'] = '@keyword',
    ['@keyword.return'] = '@keyword',
    ['@keyword.operator'] = '@keyword',
    ['@keyword.exception'] = '@keyword',
    ['@keyword.function'] = '@keyword',
    ['@keyword.import'] = '@keyword',
    ['@keyword.storage'] = '@keyword',
    ['@keyword.directive'] = '@keyword',
    ['@keyword.coroutine'] = '@keyword',
    ['@function.call'] = '@function',
    ['@function.builtin'] = '@function',
    ['@function.macro'] = '@function',
    ['@function.method'] = '@function',
    ['@function.method.call'] = '@function',
    ['@constructor'] = '@punctuation.bracket',
    ['@variable.parameter'] = '@variable',
    ['@variable.member'] = '@variable',
    ['@string.special'] = '@string.escape',
    ['@string.documentation'] = '@string',
    ['@number.float'] = '@number',
    ['@type.builtin'] = '@type',
    ['@type.qualifier'] = '@type',
    ['@type.definition'] = '@type',
    ['@tag.attribute'] = '@property',
    ['@markup.heading.1'] = '@markup.heading',
    ['@markup.heading.2'] = '@markup.heading',
    ['@markup.heading.3'] = '@markup.heading',
    ['@markup.heading.4'] = '@markup.heading',
    ['@markup.heading.5'] = '@markup.heading',
    ['@markup.heading.6'] = '@markup.heading',
    ['@none'] = 'Normal',
    -- LSP semantic tokens -> treesitter groups
    ['@lsp.type.class'] = '@type',
    ['@lsp.type.decorator'] = '@function',
    ['@lsp.type.enum'] = '@type',
    ['@lsp.type.enumMember'] = '@constant',
    ['@lsp.type.event'] = '@type',
    ['@lsp.type.function'] = '@function',
    ['@lsp.type.interface'] = '@type',
    ['@lsp.type.keyword'] = '@keyword',
    ['@lsp.type.macro'] = '@constant.macro',
    ['@lsp.type.method'] = '@function.method',
    ['@lsp.type.modifier'] = '@variable.builtin',
    ['@lsp.type.namespace'] = '@namespace',
    ['@lsp.type.number'] = '@number',
    ['@lsp.type.operator'] = '@operator',
    ['@lsp.type.parameter'] = '@variable.parameter',
    ['@lsp.type.property'] = '@property',
    ['@lsp.type.string'] = '@string',
    ['@lsp.type.struct'] = '@type',
    ['@lsp.type.type'] = '@type',
    ['@lsp.type.typeParameter'] = '@type',
    ['@lsp.type.variable'] = '@variable',
    -- telescope title variants
    TelescopePromptTitle = 'TelescopeTitle',
    TelescopeResultsTitle = 'TelescopeTitle',
    TelescopePreviewTitle = 'TelescopeTitle',
    -- legacy aliases
    VertSplit = 'WinSeparator',
    SpecialKey = 'NonText',
  }

  for group, opts in pairs(groups) do
    vim.api.nvim_set_hl(0, group, opts)
  end
  for group, target in pairs(links) do
    vim.api.nvim_set_hl(0, group, { link = target })
  end
end

return M
