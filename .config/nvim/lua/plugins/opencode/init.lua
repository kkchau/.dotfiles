local M = {}

function M.init()
    local opencode = require("opencode")

    vim.g.opencode_opts = {
      provider = {
        enabled = "terminal"
      }
    }

    vim.o.autoread = true

    vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
    vim.keymap.set({ "n", "x" }, "<leader>oo", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })

end

return M
