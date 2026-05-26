require('kickstart.core.options').setup()
require('kickstart.native.completion').setup()

require('kickstart.plugins.spec').setup()
require('kickstart.plugins.ui').setup()
require('kickstart.plugins.search').setup()
require('kickstart.plugins.git').setup()
require('kickstart.plugins.files').setup()
require('kickstart.plugins.notes').setup()
require('kickstart.plugins.lint').setup()

require('kickstart.native.lsp').setup()
require('kickstart.native.formatting').setup()
require('kickstart.native.treesitter').setup()

require('kickstart.features.terminal').setup()
require('kickstart.features.agent').setup()

require('kickstart.core.keymaps').setup()
require('kickstart.core.autocmds').setup()

-- vim: ts=2 sts=2 sw=2 et
