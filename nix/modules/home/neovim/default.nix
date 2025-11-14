{ lib
, config
, pkgs
, ...
}:
with lib; let
  cfg = config.neovim;
in
{
  options = {
    neovim.enable = mkEnableOption "enable neovim module";
    neovim.preferPrettier = mkOption {
      type = types.bool;
      default = false;
      description = ''
        When both Biome and Prettier are available, prefer Prettier for JS/TS/JSON formatting.
        Defaults to false (prefer Biome).
      '';
    };
    neovim.enableUI = mkOption { type = types.bool; default = true; description = "Enable UI plugins (devicons, heirline, theme, fidget, trouble, zen)."; };
    neovim.enableDAP = mkOption { type = types.bool; default = true; description = "Enable DAP plugins and tools."; };
    neovim.enableGit = mkOption { type = types.bool; default = true; description = "Enable Git plugins (fugitive, gitsigns)."; };
    neovim.enableTreesitter = mkOption { type = types.bool; default = true; description = "Enable Treesitter and parsers."; };
    neovim.enableHarpoon = mkOption { type = types.bool; default = true; description = "Enable Harpoon plugin and keymaps."; };
    # neovim.enableCopilot = mkOption { type = types.bool; default = true; description = "Enable GitHub Copilot plugins."; };

    # Per-language toggles
    neovim.enableTypeScript = mkOption { type = types.bool; default = true; description = "Enable TypeScript LSP/DAP/tools."; };
    neovim.enableGo = mkOption { type = types.bool; default = true; description = "Enable Go LSP/DAP/tools."; };
    neovim.enablePython = mkOption { type = types.bool; default = true; description = "Enable Python LSP/DAP/tools."; };
    neovim.enableCSharp = mkOption { type = types.bool; default = true; description = "Enable C# LSP/DAP/tools."; };

    neovim.colorscheme = mkOption { type = types.str; default = "tokyonight-storm"; description = "Neovim colorscheme name to apply (plugin must be available)."; };
    neovim.extraPlugins = mkOption { type = types.listOf types.package; default = [ ]; description = "Additional Vim plugins to load."; };
    neovim.extraLuaConfig = mkOption { type = types.lines; default = ""; description = "Extra Lua appended to module config."; };
  };

  config = mkIf cfg.enable
    {
      programs.neovim = {
        enable = true;

        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        defaultEditor = true;

        extraPackages = with pkgs;
          let
            pyrightPkg =
              if nodePackages ? pyright then nodePackages.pyright
              else if pkgs ? pyright then pkgs.pyright
              else null;
            ruffPkg =
              if python3Packages ? ruff then python3Packages.ruff
              else if pkgs ? ruff then pkgs.ruff
              else null;
            yamlLsPkg =
              if nodePackages ? yaml-language-server then nodePackages.yaml-language-server
              else null;
            jsonLsPkg =
              if pkgs ? vscode-langservers-extracted then pkgs.vscode-langservers-extracted
              else if nodePackages ? vscode-json-languageserver then nodePackages.vscode-json-languageserver
              else if pkgs ? json-lsp then pkgs.json-lsp
              else null;
            vtslsPkg =
              if nodePackages ? vtsls then nodePackages.vtsls
              else if pkgs ? vtsls then pkgs.vtsls
              else null;
            # Bash Language Server (binary: "bash-language-server")
            bashlsPkg =
              if nodePackages ? bash-language-server then nodePackages.bash-language-server
              else if pkgs ? bash-language-server then pkgs.bash-language-server
              else null;
            prettierdPkg = if nodePackages ? prettierd then nodePackages.prettierd else null;
            prettierPkg = if nodePackages ? prettier then nodePackages.prettier else null;
            biomePkg = if pkgs ? biome then pkgs.biome else null;
          in
          [
            lua-language-server
            ripgrep
            fd
            stylua
            unzip
            gcc
            tree-sitter
            nodejs

            nil
            nixpkgs-fmt

            sleek
            # XML Language Server
            lemminx
            # Protobuf tooling (includes language server)
            buf
          ]
          ++ lib.optionals cfg.enableCSharp [ roslyn-ls ]
          ++ lib.optionals cfg.enableGo [ gopls ]
          ++ lib.optionals cfg.enableTypeScript [ nodePackages.typescript nodePackages.ts-node ]
          # Python LSP/formatters
          ++ lib.optionals (pyrightPkg != null && cfg.enablePython) [ pyrightPkg ]
          ++ lib.optionals (ruffPkg != null && cfg.enablePython) [ ruffPkg ]
          ++ lib.optionals cfg.enablePython [ python3Packages.black python3Packages.isort ]
          # JS/TS tooling
          ++ lib.optionals (vtslsPkg != null && cfg.enableTypeScript) [ vtslsPkg ]
          ++ lib.optionals (prettierdPkg != null) [ prettierdPkg ]
          ++ lib.optionals (prettierPkg != null) [ prettierPkg ]
          ++ lib.optionals (biomePkg != null) [ biomePkg ]
          # YAML/JSON LSPs
          ++ lib.optionals (yamlLsPkg != null) [ yamlLsPkg ]
          ++ lib.optionals (jsonLsPkg != null) [ jsonLsPkg ]
          # Optional Go formatters
          ++ lib.optionals (pkgs ? gofumpt) [ gofumpt ]
          ++ lib.optionals (pkgs ? golines) [ golines ]
          ++ lib.optionals pkgs.stdenv.isLinux ([ xclip wl-clipboard ] ++ lib.optionals (cfg.enableDAP && cfg.enableCSharp) [ netcoredbg ])
          ++ lib.optionals pkgs.stdenv.isDarwin [ reattach-to-user-namespace ]
          # Bash tooling
          ++ lib.optionals (bashlsPkg != null) [ bashlsPkg ];

        plugins = with pkgs.vimPlugins;
          let
            jsDebugPath =
              if (builtins.hasAttr "vscode-extensions" pkgs)
                && (builtins.hasAttr "ms-vscode" pkgs.vscode-extensions)
                && (builtins.hasAttr "js-debug" pkgs.vscode-extensions."ms-vscode")
              then "${pkgs.vscode-extensions."ms-vscode"."js-debug"}/share/vscode/extensions/ms-vscode.js-debug"
              else "";
          in
          (
            [ undotree cmp-nvim-lsp cmp-path cmp-buffer cmp_luasnip lspkind-nvim ]
            ++ lib.optionals cfg.enableUI [ nvim-web-devicons ]
            ++ [ telescope-fzf-native-nvim plenary-nvim vim-nix ]
            ++ lib.optionals (cfg.enableDAP && cfg.enableGo) [ nvim-dap-go ]
            ++ lib.optionals cfg.enableDAP [ nvim-dap-ui nvim-dap-virtual-text nvim-nio ]
            ++ lib.optionals cfg.enableUI [ fidget-nvim ]
            ++ [ conform-nvim neodev-nvim SchemaStore-nvim ]
            ++ lib.optionals cfg.enableUI [ lsp_lines-nvim ]
            ++ lib.optionals cfg.enableUI [{
              plugin = which-key-nvim;
              type = "lua";
              config = builtins.readFile ./plugin/which-key.lua;
            }]
            ++ lib.optionals cfg.enableGit [{
              plugin = gitsigns-nvim;
              type = "lua";
              config = builtins.readFile ./plugin/gitsigns.lua;
            }]
            ++ lib.optionals cfg.enableUI [{
              plugin = todo-comments-nvim;
              type = "lua";
              config = ''require("todo-comments").setup()'';
            }]
            ++ [ luasnip friendly-snippets ]
            ++ lib.optionals cfg.enableHarpoon [ harpoon2 ]
            ++ lib.optionals cfg.enableGit [ vim-fugitive ]
            ++ lib.optionals cfg.enableTreesitter [{
              plugin = nvim-treesitter.withPlugins (p:
                let
                  base = [
                    p.tree-sitter-nix
                    p.tree-sitter-vim
                    p.tree-sitter-lua
                    p.tree-sitter-markdown
                    p.tree-sitter-markdown_inline
                  ]
                  ++ lib.optional (p ? tree-sitter-yaml) p.tree-sitter-yaml
                  ++ lib.optional (p ? tree-sitter-json) p.tree-sitter-json
                  ++ lib.optional (p ? tree-sitter-proto) p.tree-sitter-proto;
                  ts = lib.optionals cfg.enableTypeScript (
                    (lib.optional (p ? tree-sitter-javascript) p.tree-sitter-javascript)
                    ++ (lib.optional (p ? tree-sitter-typescript) p.tree-sitter-typescript)
                    ++ (lib.optional (p ? tree-sitter-tsx) p.tree-sitter-tsx)
                  );
                  go = lib.optionals cfg.enableGo (lib.optional (p ? tree-sitter-go) p.tree-sitter-go);
                  py = lib.optionals cfg.enablePython (lib.optional (p ? tree-sitter-python) p.tree-sitter-python);
                  cs = lib.optionals cfg.enableCSharp (lib.optional (p ? tree-sitter-c_sharp) p.tree-sitter-c_sharp);
                in
                base ++ ts ++ go ++ py ++ cs
              );
              type = "lua";
              config = builtins.readFile ./plugin/treesitter.lua;
            }
              { plugin = nvim-treesitter-textobjects; }]
            ++ [{ plugin = oil-nvim; type = "lua"; config = builtins.readFile ./plugin/oil.lua; }]
            ++ [{ plugin = obsidian-nvim; type = "lua"; config = builtins.readFile ./plugin/obsidian.lua; }]
            ++ [{ plugin = nvim-lspconfig; type = "lua"; config = builtins.readFile ./plugin/lsp.lua; }]
            ++ lib.optionals cfg.enableCSharp [{ plugin = roslyn-nvim; type = "lua"; config = builtins.readFile ./plugin/roslyn.lua; }]
            ++ [{ plugin = comment-nvim; type = "lua"; config = "require('Comment').setup()"; }]
            ++ lib.optionals cfg.enableUI [{ plugin = heirline-nvim; type = "lua"; config = builtins.readFile ./plugin/statusline.lua; }]
            ++ lib.optionals cfg.enableUI [{
              plugin = tokyonight-nvim;
              type = "lua";
              config = ''${builtins.readFile ./plugin/tokyonight.lua}
                pcall(vim.cmd.colorscheme, '${cfg.colorscheme}')
              '';
            }]
            ++ [{ plugin = nvim-cmp; type = "lua"; config = builtins.readFile ./plugin/cmp.lua; }]
            ++ [ cmp-nvim-lsp-signature-help ]
            ++ [{ plugin = telescope-nvim; type = "lua"; config = builtins.readFile ./plugin/telescope.lua; }]
            ++ lib.optionals cfg.enableDAP [{ plugin = nvim-dap; type = "lua"; config = builtins.readFile ./plugin/dap.lua; }]
            ++ lib.optionals (cfg.enableDAP && cfg.enableTypeScript) [{
              plugin = nvim-dap-vscode-js;
              type = "lua";
              config = ''
                local ok, js = pcall(require, "dap-vscode-js")
                if ok then
                  local debugger_path = "${jsDebugPath}"
                  if debugger_path ~= "" then
                    js.setup({ debugger_path = debugger_path, adapters = { 'pwa-node', 'pwa-chrome', 'pwa-extensionHost', 'node-terminal' }, })
                  end
                end
              '';
            }]
            ++ lib.optionals (cfg.enableDAP && cfg.enablePython) [ nvim-dap-python ]
            ++ [{ plugin = refactoring-nvim; type = "lua"; config = builtins.readFile ./plugin/refactoring.lua; }]
            ++ [ vim-tmux-navigator ]
            ++ lib.optionals cfg.enableUI [{ plugin = trouble-nvim; type = "lua"; config = "require('trouble').setup()"; }]
            ++ lib.optionals cfg.enableUI [{ plugin = zen-mode-nvim; type = "lua"; config = "require('zen-mode').setup()"; }]
            # ++ lib.optionals cfg.enableCopilot [ copilot-cmp { plugin = copilot-lua; type = "lua"; config = builtins.readFile ./plugin/copilot.lua; } ]
            ++ cfg.extraPlugins
          );

        extraLuaConfig = lib.concatStrings [
          ''
            -- Expose formatter preference to Lua
            vim.g.prefer_prettier = ${if cfg.preferPrettier then "true" else "false"}
          ''
          (builtins.readFile ./options.lua)
          cfg.extraLuaConfig
        ];
      };
    };
}
