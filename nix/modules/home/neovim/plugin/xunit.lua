local ok, xunit = pcall(require, "xunit")
if ok then
  xunit.setup({
    command = {
      -- perform 'dotnet clean' before running the test. Defaults to true
      clean = true,

      -- change the verbosity level of the test log: [m]inimal | [n]ormal | [d]etailed | [diag]nostic
      -- defaults to minimal. (See dotnet test --help)
      -- NOTE: more detailed logs may have impact on performance
      verbosity = "m",

      -- add additional arguments to dotnet [t]est (see dotnet test --help for all options)
      targs = {},

      -- add additional arguments to dotnet [c]lean (see dotnet clean --help for all options)
      cargs = {},
    },

    -- change the virt_text annotation text displayed in the file
    virt_text = {
      idle = "Run test",
      running = "Running...",
      passed = "Passed!",
      failed = "Failed!",
      inln_passed = "ok",
      inln_failed = "x",
    },

    -- change the border used for the popup and the log window
    border = { "┌", "─", "┐", "└", "┘", "│" },

    -- only relevant, if "nvim-notify" is a installed plugin. Enable/disable notifications
    notify = true,
  })
end
