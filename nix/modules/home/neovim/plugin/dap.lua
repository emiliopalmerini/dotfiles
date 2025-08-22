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
		local name = string.lower(variable.name)
		local value = string.lower(variable.value)
		if name:match("secret") or name:match("api") or value:match("secret") or value:match("api") then
			return "*****"
end

-- JavaScript / TypeScript via vscode-js-debug (pwa-node)
pcall(function()
  local langs = { "javascript", "typescript", "javascriptreact", "typescriptreact" }
  for _, lang in ipairs(langs) do
    dap.configurations[lang] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
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
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach to process",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
    }
  end
end)

		if #variable.value > 15 then
			return " " .. string.sub(variable.value, 1, 15) .. "... "
		end

		return " " .. variable.value
	end,
})

dap.adapters.coreclr = {
	type = "executable",
	command = "netcoredbg", -- Assicurati che netcoredbg sia nel PATH
	args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
	{
		type = "coreclr",
		name = "launch - netcoredbg",
		request = "launch",
		program = function()
			-- Ottieni il percorso del progetto
			local project_dir = vim.fn.getcwd()

			-- Cerca il file .csproj nel progetto
			local csproj_file = vim.fn.glob(project_dir .. "/*.csproj")
			if csproj_file == "" then
				return vim.fn.input(
					"File .csproj non trovato. Inserisci percorso .csproj: ",
					project_dir .. "/",
					"file"
				)
			end

			-- Leggi il file .csproj
			local file = io.open(csproj_file, "r")
			if not file then
				return vim.fn.input("Impossibile aprire .csproj. Specifica versione (es. net8.0): ", "", "file")
			end

			local content = file:read("*a")
			file:close()

			-- Estrai la versione del framework
			local version = content:match("<TargetFramework>(net[%d%.]+)</TargetFramework>")
			if not version then
				return vim.fn.input("Impossibile determinare versione. Specifica (es. net8.0): ", "", "file")
			end

			-- Configurazione di build
			local build_config = "Debug" -- o "Release"
			local build_output_dir = table.concat({
				project_dir,
				"bin",
				build_config,
				version,
			}, "/")

			-- Trova il primo file .dll
			local dll = vim.fn.glob(build_output_dir .. "/*.dll")
			if dll == "" then
				return vim.fn.input("Percorso al dll: ", build_output_dir .. "/", "file")
			end

			return dll
		end,
	},
}

vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

-- Eval var under cursor
vim.keymap.set("n", "<space>?", function()
	require("dapui").eval(nil, { enter = true })
end)

vim.keymap.set("n", "<F1>", dap.continue)
vim.keymap.set("n", "<F2>", dap.step_into)
vim.keymap.set("n", "<F3>", dap.step_over)
vim.keymap.set("n", "<F4>", dap.step_out)
vim.keymap.set("n", "<F5>", dap.step_back)
vim.keymap.set("n", "<F13>", dap.restart)

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
