local dap = require("dap")
local ui = require("dapui")

require("dapui").setup()
require("dap-go").setup()
pcall(function()
  local dap_python = require("dap-python")
  local py = vim.fn.exepath("python3")
  if py == "" then py = vim.fn.exepath("python") end
  if py == "" then py = "python3" end
  dap_python.setup(py)
end)

require("nvim-dap-virtual-text").setup({
	display_callback = function(variable)
		local name = string.lower((variable.name or ""))
		local value = tostring(variable.value or "")
		local lower_value = string.lower(value)
		if name:match("secret") or name:match("api") or lower_value:match("secret") or lower_value:match("api") then
			return "*****"
		end

		if #value > 15 then
			return " " .. string.sub(value, 1, 15) .. "... "
		end

		return " " .. value
	end,
})

-- JavaScript / TypeScript via vscode-js-debug (pwa-node)
pcall(function()
  local langs = { "javascript", "typescript", "javascriptreact", "typescriptreact" }
  local has_tsnode = vim.fn.exepath("ts-node") ~= ""
  for _, lang in ipairs(langs) do
    local configs = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach to process",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
    }
    if has_tsnode then
      table.insert(configs, 2, {
        type = "pwa-node",
        request = "launch",
        name = "Launch via ts-node",
        program = "${file}",
        cwd = "${workspaceFolder}",
        runtimeExecutable = "node",
        runtimeArgs = { "-r", "ts-node/register" },
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
      })
    end
    dap.configurations[lang] = configs
  end
end)

if vim.fn.executable("netcoredbg") == 1 then
  dap.adapters.coreclr = {
    type = "executable",
    command = "netcoredbg",
    args = { "--interpreter=vscode" },
  }

  dap.configurations.cs = {
    {
      type = "coreclr",
      name = "launch - netcoredbg",
      request = "launch",
      program = function()
        local project_dir = vim.fn.getcwd()
        local csproj_file = vim.fn.glob(project_dir .. "/*.csproj")
        if csproj_file == "" then
          return vim.fn.input("File .csproj non trovato. Inserisci percorso .csproj: ", project_dir .. "/", "file")
        end

        local file = io.open(csproj_file, "r")
        if not file then
          return vim.fn.input("Impossibile aprire .csproj. Specifica versione (es. net8.0): ", "", "file")
        end

        local content = file:read("*a"); file:close()
        local version = content:match("<TargetFramework>(net[%d%.]+)</TargetFramework>")
        if not version then
          return vim.fn.input("Impossibile determinare versione. Specifica (es. net8.0): ", "", "file")
        end

        local build_config = "Debug"
        local build_output_dir = table.concat({ project_dir, "bin", build_config, version }, "/")
        local dll = vim.fn.glob(build_output_dir .. "/*.dll")
        if dll == "" then
          return vim.fn.input("Percorso al dll: ", build_output_dir .. "/", "file")
        end
        return dll
      end,
    },
  }
end

vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

-- Eval var under cursor
vim.keymap.set("n", "<space>?", function()
	require("dapui").eval(nil, { enter = true })
end)

vim.keymap.set("n", "<F5>", dap.continue)
vim.keymap.set("n", "<F10>", dap.step_over)
vim.keymap.set("n", "<F11>", dap.step_into)
vim.keymap.set("n", "<F12>", dap.step_out)

-- Leader-based DAP mappings for discoverability (which-key)
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: Continue" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Debug: Step Out" })
vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Debug: Restart" })
vim.keymap.set("n", "<leader>de", function() require("dapui").eval(nil, { enter = true }) end, { desc = "Debug: Eval" })

dap.listeners.before.attach.dapui_config = function()
	ui.open()
end
dap.listeners.before.launch.dapui_config = function()
	ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	ui.close()
end
