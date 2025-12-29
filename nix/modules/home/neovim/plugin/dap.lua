-- Lazy-loaded DAP configuration
-- This file is sourced when DAP is first used

local dap = require("dap")
local ui = require("dapui")

require("dapui").setup()
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

-- Go DAP
pcall(function()
	require("dap-go").setup()
end)

-- JavaScript / TypeScript via vscode-js-debug (pwa-node)
pcall(function()
	local langs = { "javascript", "typescript", "javascriptreact", "typescriptreact" }
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
		dap.configurations[lang] = configs
	end
end)

-- C# DAP via netcoredbg
if vim.fn.executable("netcoredbg") == 1 then
	dap.adapters.coreclr = {
		type = "executable",
		command = "netcoredbg",
		args = { "--interpreter=vscode" },
	}

	local dotnet_project_cache = {}

	local function find_dotnet_project()
		if dotnet_project_cache.dll then
			return dotnet_project_cache
		end

		local project_dir = vim.fn.getcwd()
		local csproj_file = vim.fn.glob(project_dir .. "/*.csproj")
		if csproj_file == "" then
			local patterns = {
				project_dir .. "/src/**/*.API.csproj",
				project_dir .. "/src/**/*.Web.csproj",
				project_dir .. "/**/*.API.csproj",
				project_dir .. "/**/*.Web.csproj",
				project_dir .. "/src/**/*.csproj",
				project_dir .. "/**/*.csproj",
			}

			local candidates = {}
			for _, pattern in ipairs(patterns) do
				candidates = vim.fn.glob(pattern, false, true)
				if #candidates > 0 then
					break
				end
			end

			if #candidates == 1 then
				csproj_file = candidates[1]
			elseif #candidates > 1 then
				local choices = {}
				for i, c in ipairs(candidates) do
					table.insert(choices, string.format("%d: %s", i, c:gsub(project_dir .. "/", "")))
				end
				local choice = vim.fn.inputlist(choices)
				if choice > 0 and choice <= #candidates then
					csproj_file = candidates[choice]
				else
					csproj_file = vim.fn.input("Path to .csproj: ", project_dir .. "/", "file")
				end
			else
				csproj_file = vim.fn.input("No .csproj found. Enter path: ", project_dir .. "/", "file")
			end
		end

		local csproj_dir = vim.fn.fnamemodify(csproj_file, ":h")
		local project_name = vim.fn.fnamemodify(csproj_file, ":t:r")

		local file = io.open(csproj_file, "r")
		if not file then
			dotnet_project_cache = { cwd = csproj_dir, dll = vim.fn.input("Cannot open .csproj. Path to dll: ", csproj_dir .. "/bin/Debug/", "file") }
			return dotnet_project_cache
		end

		local content = file:read("*a")
		file:close()
		local version = content:match("<TargetFramework>(net[%d%.]+)</TargetFramework>")
		if not version then
			version = vim.fn.input("Cannot determine version. Enter (e.g. net8.0): ")
		end

		local build_config = "Debug"
		local build_output_dir = table.concat({ csproj_dir, "bin", build_config, version }, "/")

		local dll = build_output_dir .. "/" .. project_name .. ".dll"
		if vim.fn.filereadable(dll) == 0 then
			local dlls = vim.fn.glob(build_output_dir .. "/*.dll", false, true)
			if #dlls == 0 then
				dll = vim.fn.input("DLL not found. Run 'dotnet build' first.\nPath to dll: ", build_output_dir .. "/", "file")
			else
				dll = dlls[1]
			end
		end

		dotnet_project_cache = { cwd = csproj_dir, dll = dll }
		return dotnet_project_cache
	end

	dap.listeners.before.event_terminated.dotnet_cache = function()
		dotnet_project_cache = {}
	end
	dap.listeners.before.event_exited.dotnet_cache = function()
		dotnet_project_cache = {}
	end

	dap.configurations.cs = {
		{
			type = "coreclr",
			name = "launch - netcoredbg",
			request = "launch",
			program = function()
				return find_dotnet_project().dll
			end,
			cwd = function()
				return find_dotnet_project().cwd
			end,
			env = {
				ASPNETCORE_ENVIRONMENT = "Development",
				DOTNET_ENVIRONMENT = "Development",
			},
			stopAtEntry = false,
		},
	}
end

-- Zig via lldb
if vim.fn.executable("lldb") == 1 then
	if not dap.adapters.lldb then
		dap.adapters.lldb = {
			type = "executable",
			command = "lldb-vscode",
		}
	end

	dap.configurations.zig = {
		{
			type = "lldb",
			request = "launch",
			name = "Launch (LLDB)",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/zig-cache/bin/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = {},
		},
		{
			type = "lldb",
			request = "launch",
			name = "Launch built binary",
			program = "${workspaceFolder}/zig-cache/bin/${workspaceFolderBasename}",
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = {},
		},
	}
end

-- DAP UI auto open/close
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
