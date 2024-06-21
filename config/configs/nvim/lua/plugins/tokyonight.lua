require('tokyonight').setup {
  -- style = "storm",
  -- style = "storm",
  -- style = "storm",
  style = 'moon',
  light_style = 'night',
  transparent = true,
  terminal_colors = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    sidebars = 'dark',
    floats = 'dark',
  },
  sidebars = { 'qf', 'help' },
  day_brightness = 0.3,
  hide_inactive_statusline = false,
  dim_inactive = false,
  lualine_bold = false,

  ---@param colors ColorScheme
  on_colors = function(colors) end,

  ---@param highlights Highlights
  ---@param colors ColorScheme
  on_highlights = function(highlights, colors) end,
}

vim.cmd.colorscheme 'tokyonight-moon'
