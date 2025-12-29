{ lib, pkgs }:

let
  mkLang =
    { packages ? [ ]
    , treesitterGrammars ? (_: [ ])
    , dapPlugins ? [ ]
    , plugins ? [ ]
    , lsp ? { }
    , detectPackage ? null
    }:
    { inherit packages treesitterGrammars dapPlugins plugins lsp; }
    // lib.optionalAttrs (detectPackage != null) { inherit detectPackage; };
in
{
  # Core languages (always enabled)
  nix = mkLang {
    packages = [ pkgs.nil pkgs.nixpkgs-fmt ];
    treesitterGrammars = p: [ p.tree-sitter-nix ];
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

  lua = mkLang {
    packages = [ pkgs.lua-language-server pkgs.stylua ];
    treesitterGrammars = p: [ p.tree-sitter-lua p.tree-sitter-vim ];
    lsp.lua_ls = ''
      {
        server_capabilities = { semanticTokensProvider = vim.NIL },
      }
    '';
  };

  bash = mkLang {
    packages = [ pkgs.nodePackages.bash-language-server ];
    treesitterGrammars = p: lib.optional (p ? tree-sitter-bash) p.tree-sitter-bash;
    lsp.bashls = ''
      {
        cmd = { "bash-language-server", "start" },
        filetypes = { "sh", "bash" },
      }
    '';
  };

  yaml = mkLang {
    packages = [ pkgs.nodePackages.yaml-language-server ];
    treesitterGrammars = p: lib.optional (p ? tree-sitter-yaml) p.tree-sitter-yaml;
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

  json = mkLang {
    packages = [ pkgs.vscode-langservers-extracted ];
    treesitterGrammars = p: lib.optional (p ? tree-sitter-json) p.tree-sitter-json;
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

  xml = mkLang {
    packages = [ pkgs.lemminx ];
    lsp.lemminx = "{}";
  };

  protobuf = mkLang {
    packages = [ pkgs.buf ];
    treesitterGrammars = p: lib.optional (p ? tree-sitter-proto) p.tree-sitter-proto;
    lsp.buf_ls = ''
      {
        cmd = { "buf", "beta", "lsp" },
      }
    '';
  };

  sql = mkLang {
    packages = [ pkgs.sleek ];
  };

  markdown = mkLang {
    treesitterGrammars = p: [ p.tree-sitter-markdown p.tree-sitter-markdown_inline ];
  };

  # Project languages (auto-detected)
  go = mkLang {
    detectPackage = "go";
    packages = [ pkgs.gopls pkgs.gofumpt pkgs.golines ];
    treesitterGrammars = p: lib.optional (p ? tree-sitter-go) p.tree-sitter-go;
    dapPlugins = [ pkgs.vimPlugins.nvim-dap-go ];
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

  csharp = mkLang {
    detectPackage = "dotnet-sdk";
    packages = [ pkgs.roslyn-ls ] ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.netcoredbg ];
    treesitterGrammars = p: lib.optional (p ? tree-sitter-c_sharp) p.tree-sitter-c_sharp;
    plugins = [
      { plugin = pkgs.vimPlugins.roslyn-nvim; type = "lua"; }
    ];
    lsp.roslyn = ''
      {
        dotnet_cmd = "dotnet",
        roslyn_version = "4.12.0-2.24421.11",
        choose_target = function(targets)
          if #targets == 1 then
            return targets[1]
          end
          -- Filter out solutions in parent directories
          local local_targets = vim.tbl_filter(function(t)
            local rel = vim.fn.fnamemodify(t, ":.")
            return not vim.startswith(rel, "..")
          end, targets)
          if #local_targets > 0 then
            targets = local_targets
          end
          -- Pick the closest one
          table.sort(targets, function(a, b)
            return #vim.fn.fnamemodify(a, ":.") < #vim.fn.fnamemodify(b, ":.")
          end)
          return targets[1]
        end,
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
            dotnet_analyzer_diagnostics_scope = "openFiles",
            dotnet_compiler_diagnostics_scope = "openFiles",
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
          ["csharp|completion"] = {
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

  c = mkLang {
    detectPackage = "gcc";
    packages = [ pkgs.clang-tools ];
    treesitterGrammars = p:
      (lib.optional (p ? tree-sitter-c) p.tree-sitter-c)
      ++ (lib.optional (p ? tree-sitter-cpp) p.tree-sitter-cpp);
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

  rust = mkLang {
    detectPackage = "rustc";
    packages = [ pkgs.rust-analyzer pkgs.rustfmt ];
    treesitterGrammars = p: lib.optional (p ? tree-sitter-rust) p.tree-sitter-rust;
    lsp.rust_analyzer = "{}";
  };

  zig = mkLang {
    detectPackage = "zig";
    packages = [ pkgs.zls pkgs.lldb ];
    treesitterGrammars = p: lib.optional (p ? tree-sitter-zig) p.tree-sitter-zig;
    lsp.zls = "{}";
  };

  elixir = mkLang {
    detectPackage = "elixir";
    packages = [ pkgs.elixir-ls ];
    treesitterGrammars = p:
      (lib.optional (p ? tree-sitter-elixir) p.tree-sitter-elixir)
      ++ (lib.optional (p ? tree-sitter-heex) p.tree-sitter-heex)
      ++ (lib.optional (p ? tree-sitter-eex) p.tree-sitter-eex);
    lsp.elixirls = "{}";
  };

  python = mkLang {
    detectPackage = "python3";
    packages = [ pkgs.pyright pkgs.black pkgs.isort ];
    treesitterGrammars = p: lib.optional (p ? tree-sitter-python) p.tree-sitter-python;
    lsp.pyright = ''
      {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      }
    '';
  };

  typescript = mkLang {
    detectPackage = "nodejs";
    packages = [
      pkgs.nodePackages.typescript-language-server
      pkgs.nodePackages.typescript
      pkgs.nodePackages.prettier
    ];
    treesitterGrammars = p:
      (lib.optional (p ? tree-sitter-javascript) p.tree-sitter-javascript)
      ++ (lib.optional (p ? tree-sitter-typescript) p.tree-sitter-typescript)
      ++ (lib.optional (p ? tree-sitter-tsx) p.tree-sitter-tsx);
    lsp.ts_ls = ''
      {
        init_options = {
          preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      }
    '';
  };
}
