vim.api.nvim_create_user_command(
    'Pytest',
    function()
        util.run_in_float(':term pytest -rP --durations=0 ' .. vim.api.nvim_buf_get_name(0))
    end,
    {}
)

vim.api.nvim_create_user_command(
    'PytestFunc',
    function()
        -- Iterate through parents until we get to a function definition
        local cur_node = vim.treesitter.get_node()
        while cur_node:type() ~= 'function_definition' do
            cur_node = cur_node:parent()
            if cur_node == nil then return end
        end

        local function_identifier = vim.treesitter.get_node_text(cur_node:named_child(), 0)
        util.run_in_float(':term pytest -rP -k ' .. function_identifier .. ' ' .. vim.api.nvim_buf_get_name(0))
    end,
    {}
)
