local create_cmd = function(cmd, func, opt)
    opt = vim.tbl_extend('force', { desc = 'manim.nvim ' .. cmd }, opt or {})
    vim.api.nvim_create_user_command(cmd, func, opt)
end

return {
    add_cmds = function()
        create_cmd('ManimPreview', function(_)
            local cword = vim.api.nvim_eval([[expand('<cword>')]])
            local file = vim.api.nvim_buf_get_name(0)
            local cmd = "manim " .. file .. " " .. cword .. " -p"
            local job = vim.fn.jobstart(
                cmd
            )
        end)
    end
}
