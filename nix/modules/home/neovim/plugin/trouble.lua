vim.keymap.set("n", "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>", {
  desc = "Diagnostics (Trouble)",
})

vim.keymap.set("n", "<leader>tT", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", {
  desc = "Buffer Diagnostics (Trouble)",
})

vim.keymap.set("n", "<leader>tL", "<cmd>Trouble loclist toggle<cr>", {
  desc = "Location List (Trouble)",
})

vim.keymap.set("n", "<leader>tQ", "<cmd>Trouble qflist toggle<cr>", {
  desc = "Quickfix List (Trouble)",
})

