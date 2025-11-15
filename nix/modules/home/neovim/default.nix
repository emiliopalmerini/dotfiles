{ lib
, config
, pkgs
, ...
}:
with lib; let
  cfg = config.neovim;

  hasPackage = pkgName: builtins.any (pkg: pkg.pname or "" == pkgName) config.home.packages;

  # Centralized language configuration - single source of truth
  # To add a new language, just add an entry here with:
  # - detectPackage: package name to auto-detect
  # - packages: LSPs, formatters, linters to install
  # - treesitterGrammars: function returning list of grammars
  # - dapPlugins: debugger plugins (can be empty)
  # - plugins: any special vim plugins (can be empty)
  languageConfigs = {
    go = {
      detectPackage = "go";
      packages = with pkgs; [ gopls gofumpt golines ];
      treesitterGrammars = p: lib.optional (p ? tree-sitter-go) p.tree-sitter-go;
      dapPlugins = [ pkgs.vimPlugins.nvim-dap-go ];
      plugins = [ ];
    };

    typescript = {
      detectPackage = "nodejs";
      packages = with pkgs; [
        nodePackages.typescript
        nodePackages.ts-node
        nodePackages.vtsls
      ];
      treesitterGrammars = p:
        (lib.optional (p ? tree-sitter-javascript) p.tree-sitter-javascript)
        ++ (lib.optional (p ? tree-sitter-typescript) p.tree-sitter-typescript)
        ++ (lib.optional (p ? tree-sitter-tsx) p.tree-sitter-tsx);
      dapPlugins = [ ]; # Handled separately due to jsDebugPath config requirement
      plugins = [ ];
    };

    python = {
      detectPackage = "python3";
      packages = with pkgs; [
        python3Packages.pyright
        python3Packages.ruff
        python3Packages.black
        python3Packages.isort
      ];
      treesitterGrammars = p: lib.optional (p ? tree-sitter-python) p.tree-sitter-python;
      dapPlugins = [ pkgs.vimPlugins.nvim-dap-python ];
      plugins = [ ];
    };

    csharp = {
      detectPackage = "dotnet-sdk";
      packages = with pkgs; [ roslyn-ls ] ++ lib.optionals pkgs.stdenv.isLinux [ netcoredbg ];
      treesitterGrammars = p: lib.optional (p ? tree-sitter-c_sharp) p.tree-sitter-c_sharp;
      dapPlugins = [ ];
      plugins = [{ plugin = pkgs.vimPlugins.roslyn-nvim; type = "lua"; config = builtins.readFile ./plugin/roslyn.lua; }];
    };

  isLanguageEnabled = name: langCfg:
    if langCfg ? detectPackage
    then hasPackage langCfg.detectPackage || hasPackage (builtins.replaceStrings [ "-sdk" ] [ "" ] langCfg.detectPackage)
    else true;

  enabledLanguages = lib.filterAttrs isLanguageEnabled languages;

  languagePackages = lib.flatten (lib.mapAttrsToList (_: lang: lang.packages) enabledLanguages);
  languageTreesitterGrammars = p: lib.flatten (lib.mapAttrsToList (_: lang: lang.treesitterGrammars p) enabledLanguages);
  languageDapPlugins = lib.flatten (lib.mapAttrsToList (_: lang: lang.dapPlugins) enabledLanguages);
  languagePlugins = lib.flatten (lib.mapAttrsToList (_: lang: lang.plugins) enabledLanguages);
in
{
  options = {
    neovim.enable = mkEnableOption "enable neovim module";

    # Extensibility
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

        extraPackages = with pkgs; [
          # Base tooling
          lua-language-server
          ripgrep
          fd
          stylua
          unzip
          gcc
          tree-sitter
          nodejs

          # Nix
          nil
          nixpkgs-fmt

          # Task management
          sleek
          # XML Language Server
          lemminx
          # Protobuf tooling (includes language server)
          buf

          # YAML/JSON LSPs
          nodePackages.yaml-language-server
          vscode-langservers-extracted

          # JS/TS formatters
          nodePackages.prettierd
          nodePackages.prettier
          biome

          # Bash tooling
          nodePackages.bash-language-server
        ]
        ++ languagePackages
        ++ lib.optionals pkgs.stdenv.isLinux [ xclip wl-clipboard ]
        ++ lib.optionals pkgs.stdenv.isDarwin [ reattach-to-user-namespace ];

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
            ++ lib.optionals cfg.enableDAP languageDapPlugins
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
                  languageGrammars = languageTreesitterGrammars p;
                in
                base ++ languageGrammars
              );
              type = "lua";
              config = builtins.readFile ./plugin/treesitter.lua;
            }
              { plugin = nvim-treesitter-textobjects; }]
            ++ [{ plugin = oil-nvim; type = "lua"; config = builtins.readFile ./plugin/oil.lua; }]
            ++ [{ plugin = obsidian-nvim; type = "lua"; config = builtins.readFile ./plugin/obsidian.lua; }]
            ++ [{ plugin = nvim-lspconfig; type = "lua"; config = builtins.readFile ./plugin/lsp.lua; }]
            ++ languagePlugins
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
            ++ lib.optionals (cfg.enableDAP && builtins.hasAttr "typescript" enabledLanguages) [{
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
