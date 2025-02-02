local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>a", function()
    harpoon:list():add()
end, { desc = "[A]ppend file to harpoon" })
vim.keymap.set("n", "<leader>h", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Open [H]arpoon list" })

for _, idx in ipairs({ 1, 2, 3, 4, 5 }) do
    vim.keymap.set("n", string.format("<space>%d", idx), function()
        harpoon:list():select(idx)
    end)
end
