

-- Transparent background
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
-- Sky blue color

-- Read a color from Matugen colors.css
local function get_matugen_color(name)
  local path = vim.fn.expand("~/.config/waybar/matugen/colors.css")
  local file = io.open(path, "r")
  if not file then return nil end

  for line in file:lines() do
    local key, value = line:match("@define%-color%s+(%S+)%s+(#%x+);")
    if key == name then
      file:close()
      return value
    end
  end

  file:close()
  return nil
end


local primary = get_matugen_color("primary")
local on_primary = get_matugen_color("on_primary")

vim.api.nvim_set_hl(0, "StatusFilename", {
  fg = "#000000",
  bg = primary,
  bold = true,
})


vim.o.statusline = table.concat {
  "%#StatusLine#",
  " ",
  "%#StatusFilename#",
  " %f ",
  "%#StatusLine#",
  "%=",
  "%l:%c ",
}



