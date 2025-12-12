{ lib, pkgs }:

{
   # Core languages (always enabled)
   nix = {
     packages = [ pkgs.nil pkgs.nixpkgs-fmt ];
     treesitterGrammars = p: [ p.tree-sitter-nix ];
     dapPlugins = [ ];
     plugins = [ ];
     lsp.nil_ls = ''
       {
         settings = {
           ["nil"] = {
             formatting = { command = { "nixpkgs-fmt" } },
             nix = { flake = { autoEvalInputs = true } },
           },
         },
       }
     '';
   };
  lua = {
    packages = [ pkgs.lua-language-server pkgs.stylua ];
    treesitterGrammars = p: [ p.tree-sitter-lua p.tree-sitter-vim ];
    dapPlugins = [ ];
    plugins = [ ];
    lsp.lua_ls = ''
      {
        server_capabilities = { semanticTokensProvider = vim.NIL },
      }
    '';
  };
  bash = {
    packages = [ pkgs.nodePackages.bash-language-server ];
    treesitterGrammars = p: lib.optional (p ? tree-sitter-bash) p.tree-sitter-bash;
    dapPlugins = [ ];
    plugins = [ ];
    lsp.bashls = ''
      {
        cmd = { "bash-language-server", "start" },
        filetypes = { "sh", "bash" },
      }
    '';
  };
  yaml = {
    packages = [ pkgs.nodePackages.yaml-language-server ];
    treesitterGrammars = p: lib.optional (p ? tree-sitter-yaml) p.tree-sitter-yaml;
    dapPlugins = [ ];
    plugins = [ ];
    lsp.yamlls = ''
      {
        settings = {
          yaml = {
            schemas = (function()
              local ok, schemastore = pcall(require, "schemastore")
              if ok then return schemastore.yaml.schemas() end
              return nil
            end)(),
          },
        },
      }
    '';
  };
  json = {
    packages = [ pkgs.vscode-langservers-extracted ];
    treesitterGrammars = p: lib.optional (p ? tree-sitter-json) p.tree-sitter-json;
    dapPlugins = [ ];
    plugins = [ ];
    lsp.jsonls = ''
      {
        settings = {
          json = {
            schemas = (function()
              local ok, schemastore = pcall(require, "schemastore")
              if ok then return schemastore.json.schemas() end
              return nil
            end)(),
            validate = { enable = true },
          },
        },
      }
    '';
  };
  xml = {
    packages = [ pkgs.lemminx ];
    treesitterGrammars = p: [ ];
    dapPlugins = [ ];
    plugins = [ ];
    lsp.lemminx = "true";
  };
  protobuf = {
    packages = [ pkgs.buf ];
    treesitterGrammars = p: lib.optional (p ? tree-sitter-proto) p.tree-sitter-proto;
    dapPlugins = [ ];
    plugins = [ ];
    lsp.bufls = "true";
  };
  sql = {
    packages = [ pkgs.sleek ];
    treesitterGrammars = p: [ ];
    dapPlugins = [ ];
    plugins = [ ];
    lsp = { };
  };
  markdown = {
    packages = [ ];
    treesitterGrammars = p: [ p.tree-sitter-markdown p.tree-sitter-markdown_inline ];
    dapPlugins = [ ];
    plugins = [ ];
    lsp = { };
  };

  # Project languages (auto-detected)
  go = {
    detectPackage = "go";
    packages = [ pkgs.gopls pkgs.gofumpt pkgs.golines ];
    treesitterGrammars = p: lib.optional (p ? tree-sitter-go) p.tree-sitter-go;
    dapPlugins = [ pkgs.vimPlugins.nvim-dap-go ];
    plugins = [ ];
    lsp.gopls = ''
      {
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      }
    '';
  };
  typescript = {
    detectPackage = "nodejs";
    packages = [
      pkgs.nodePackages.typescript
    ];
    treesitterGrammars = p:
      (lib.optional (p ? tree-sitter-javascript) p.tree-sitter-javascript)
      ++ (lib.optional (p ? tree-sitter-typescript) p.tree-sitter-typescript)
      ++ (lib.optional (p ? tree-sitter-tsx) p.tree-sitter-tsx);
    dapPlugins = [ ];
    plugins = [ ];
    lsp.__ts_server = "true";
  };
  python = {
    detectPackage = "python3";
    packages = [
      pkgs.python3Packages.pyright
      pkgs.python3Packages.ruff
      pkgs.python3Packages.black
      pkgs.python3Packages.isort
    ];
    treesitterGrammars = p: lib.optional (p ? tree-sitter-python) p.tree-sitter-python;
    dapPlugins = [ pkgs.vimPlugins.nvim-dap-python ];
    plugins = [ ];
    lsp = {
      pyright = "true";
      ruff = "true";
    };
  };
  csharp = {
    detectPackage = "dotnet-sdk";
    packages = [ pkgs.roslyn-ls ] ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.netcoredbg ];
    treesitterGrammars = p: lib.optional (p ? tree-sitter-c_sharp) p.tree-sitter-c_sharp;
    dapPlugins = [ ];
    plugins = [
      { plugin = pkgs.vimPlugins.roslyn-nvim; type = "lua"; }
    ];
    lsp.roslyn = ''
      {
        dotnet_cmd = "dotnet",
        roslyn_version = "4.12.0-2.24421.11",
        broad_search = true,
        lock_target = false,
        on_attach = function(client, bufnr)
          -- Enable inlay hints if supported
          if client.server_capabilities and client.server_capabilities.inlayHintProvider then
            local ih = vim.lsp.inlay_hint
            if type(ih) == "table" and ih.enable then
              ih.enable(true, { bufnr = bufnr })
            elseif type(ih) == "function" then
              ih(bufnr, true)
            end
          end
        end,
        settings = {
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "fullSolution",
            dotnet_compiler_diagnostics_scope = "fullSolution",
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
          ["csharp|compleation"] = {
            dotnet_provide_regex_completions = true,
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
          },
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
        },
      }
    '';
  };
  c = {
    detectPackage = "gcc";
    packages = [ pkgs.clang-tools ];
    treesitterGrammars = p:
      (lib.optional (p ? tree-sitter-c) p.tree-sitter-c)
      ++ (lib.optional (p ? tree-sitter-cpp) p.tree-sitter-cpp);
    dapPlugins = [ ];
    plugins = [ ];
    lsp.clangd = ''
      {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
        capabilities = { offsetEncoding = { "utf-16" } },
      }
    '';
  };
  rust = {
    detectPackage = "rustc";
    packages = [ pkgs.rust-analyzer pkgs.rustfmt ];
    treesitterGrammars = p: lib.optional (p ? tree-sitter-rust) p.tree-sitter-rust;
    dapPlugins = [ ];
    plugins = [ ];
    lsp.rust_analyzer = "true";
  };
  zig = {
    detectPackage = "zig";
    packages = [ pkgs.zls pkgs.lldb ];
    treesitterGrammars = p: lib.optional (p ? tree-sitter-zig) p.tree-sitter-zig;
    dapPlugins = [ ];
    plugins = [ ];
    lsp.zls = "true";
  };
  elixir = {
    detectPackage = "elixir";
    packages = [ pkgs.elixir-ls ];
    treesitterGrammars = p:
      (lib.optional (p ? tree-sitter-elixir) p.tree-sitter-elixir)
      ++ (lib.optional (p ? tree-sitter-heex) p.tree-sitter-heex)
      ++ (lib.optional (p ? tree-sitter-eex) p.tree-sitter-eex);
    dapPlugins = [ ];
    plugins = [ ];
    lsp.elixirls = "true";
  };
}
