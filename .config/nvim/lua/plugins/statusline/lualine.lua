require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {{'filename', path = 2}},
    lualine_b = {},
    lualine_c = {'branch', 'diff', 'diagnostics'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {},
    lualine_z = {'progress', 'location'}
  },
  tabline = {
    lualine_a = {'buffers'},
  }
})
