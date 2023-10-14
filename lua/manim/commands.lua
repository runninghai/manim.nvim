local create_cmd = function(cmd, func, opt)
    opt = vim.tbl_extend('force', { desc = 'manim.nvim ' .. cmd }, opt or {})
    vim.api.nvim_create_user_command(cmd, func, opt)
end


return {
    add_cmds = function()
        create_cmd('ManimPreview', function(_)
            local ts_utils = require 'nvim-treesitter.ts_utils'
            local node = ts_utils.get_node_at_cursor()

            while node do
                if node:type() == "class_definition" then
                    break
                end
                node = node:parent()
            end
            if not node then
                vim.notify("class not found", vim.log.levels.ERROR)
                return
            end

            local class_name = (vim.treesitter.get_node_text(node:child(1), vim.api.nvim_get_current_buf()))
            if not class_name then
                vim.notify("class name not found", vim.log.levels.ERROR)
                return
            end

            local file = vim.api.nvim_buf_get_name(0)
            local cmd = "manim " .. file .. " " .. class_name .. " -p"
            local job = vim.fn.jobstart(
                cmd,
                {
                    on_stdout = function(_, data, _)
                        vim.notify(data, vim.log.levels.INFO)
                    end,
                    on_stderr = function(_, data, _)
                        vim.notify(data, vim.log.levels.ERROR)
                    end,
                }

            )
        end)
    end
}
