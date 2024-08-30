return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup()

        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "[A]ppend file to harpoon" })
        vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Open [H]arpoon list" })

        vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Select 1st file from harpoon list" })
        vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Select 2nd file from harpoon list" })
        vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Select 3rd file from harpoon list" })
        vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Select 4th file from harpoon list" })
        vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end, { desc = "Select 5th file from harpoon list" })
    end
}

