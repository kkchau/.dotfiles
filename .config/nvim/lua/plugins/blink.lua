vim.pack.add({
    {
        src = 'https://github.com/Saghen/blink.cmp',
        version = vim.version.range('*')
    }
})
require('blink.cmp').setup({
    fuzzy = {
        prebuilt_binaries = {
            download = true
        }
    },
    completion = {
        ghost_text = {
            enabled = true
        },
        list = {
            selection = {
                preselect = false
            },
        }
    },
    keymap = {
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
    }
})
