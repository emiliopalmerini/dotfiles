return {
    "tpope/vim-fugitive",
    config = function()
        -- Open the Git status window
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Open Git status window" })

        local emilio_fugitive = vim.api.nvim_create_augroup("emilio_fugitive", {})

        local autocmd = vim.api.nvim_create_autocmd
        autocmd("BufWinEnter", {
            group = emilio_fugitive,
            pattern = "*",
            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()
                local opts = {buffer = bufnr, remap = false}

                -- Push the current branch to the remote
                vim.keymap.set("n", "<leader>gp", function()
                    vim.cmd.Git('push')
                end, opts, { desc = "Push current branch to remote" })

                -- Force push the current branch to the remote
                vim.keymap.set("n", "<leader>gf", function()
                    vim.cmd.Git('push --force')
                end, opts, { desc = "Force push current branch to remote" })

                -- Rebase and pull from the remote branch
                vim.keymap.set("n", "<leader>gP", function()
                    vim.cmd.Git({'pull'})
                end, opts, { desc = "Pull from remote with rebase" })

                -- Set upstream branch and push
                vim.keymap.set("n", "<leader>gt", ":Git push -u origin ", opts, { desc = "Set upstream branch and push" })
                vim.keymap.set("n", "<leader>g", ":Git push -u origin ", opts, { desc = "Set upstream branch and push" })
            end,
        })
    end
}

