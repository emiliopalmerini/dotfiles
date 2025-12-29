{ lib
, config
, pkgs
, ...
}:
with lib; let
  cfg = config.neovim;

  hasPackage = pkgName: builtins.any (pkg: pkg.pname or "" == pkgName) config.home.packages;

  languages = import ./languages.nix { inherit lib pkgs; };

  isLanguageEnabled = name: langCfg:
    if langCfg ? detectPackage
    then hasPackage langCfg.detectPackage || hasPackage (builtins.replaceStrings [ "-sdk" ] [ "" ] langCfg.detectPackage)
    else true;

  enabledLanguages = lib.filterAttrs isLanguageEnabled languages;

  languagePackages = lib.flatten (lib.mapAttrsToList (_: lang: lang.packages) enabledLanguages);
  languageTreesitterGrammars = p: lib.flatten (lib.mapAttrsToList (_: lang: lang.treesitterGrammars p) enabledLanguages);
  languageDapPlugins = lib.flatten (lib.mapAttrsToList (_: lang: lang.dapPlugins) enabledLanguages);
  languagePlugins = lib.flatten (lib.mapAttrsToList (_: lang: lang.plugins) enabledLanguages);

  # Generate LSP servers table from enabled languages
  languageLspConfigs = lib.flatten (lib.mapAttrsToList
    (_: lang: lib.mapAttrsToList (name: config: { inherit name config; }) (lang.lsp or { }))
    enabledLanguages);

  generateLspServersLua = configs:
    let
      entries = map (c: ''["${c.name}"] = ${c.config}'') configs;
    in
    "{\n  ${lib.concatStringsSep ",\n  " entries}\n}";
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

        extraPackages = [
          # Base tooling
          pkgs.ripgrep
          pkgs.fd
          pkgs.unzip
          pkgs.gcc
          pkgs.tree-sitter
          pkgs.nodejs

        ]
        ++ languagePackages
        ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.xclip pkgs.wl-clipboard ]
        ++ lib.optionals pkgs.stdenv.isDarwin [ pkgs.reattach-to-user-namespace ];

        plugins =
          let
            vp = pkgs.vimPlugins;
            jsDebugPath =
              if (builtins.hasAttr "vscode-extensions" pkgs)
                && (builtins.hasAttr "ms-vscode" pkgs.vscode-extensions)
                && (builtins.hasAttr "js-debug" pkgs.vscode-extensions."ms-vscode")
              then "${pkgs.vscode-extensions."ms-vscode"."js-debug"}/share/vscode/extensions/ms-vscode.js-debug"
              else "";
          in
          [
            # Core plugins
            vp.undotree
            vp.cmp-nvim-lsp
            vp.cmp-path
            vp.cmp-buffer
            vp.cmp_luasnip
            vp.lspkind-nvim
            vp.nvim-web-devicons
            vp.telescope-fzf-native-nvim
            vp.plenary-nvim
            vp.vim-nix
            vp.conform-nvim
            vp.neodev-nvim
            vp.SchemaStore-nvim
            vp.luasnip
            vp.friendly-snippets
            vp.harpoon2
            vp.vim-fugitive
            vp.fidget-nvim

            # UI plugins with config
            {
              plugin = vp.which-key-nvim;
              type = "lua";
              config = builtins.readFile ./plugin/which-key.lua;
            }
            {
              plugin = vp.gitsigns-nvim;
              type = "lua";
              config = builtins.readFile ./plugin/gitsigns.lua;
            }
            {
              plugin = vp.todo-comments-nvim;
              type = "lua";
              config = ''require("todo-comments").setup()'';
            }

            # DAP plugins
            vp.nvim-dap-ui
            vp.nvim-dap-virtual-text
            vp.nvim-nio

            # Treesitter
            {
              plugin = vp.nvim-treesitter.withPlugins languageTreesitterGrammars;
              type = "lua";
              config = builtins.readFile ./plugin/treesitter.lua;
            }
            { plugin = vp.nvim-treesitter-textobjects; }

            # File navigation
            { plugin = vp.oil-nvim; type = "lua"; config = builtins.readFile ./plugin/oil.lua; }

            # Note taking
            { plugin = vp.obsidian-nvim; type = "lua"; config = builtins.readFile ./plugin/obsidian.lua; }

            # LSP
            {
              plugin = vp.nvim-lspconfig;
              type = "lua";
              config = ''
                local language_servers = ${generateLspServersLua languageLspConfigs}
                ${builtins.readFile ./plugin/lsp.lua}
              '';
            }

            # Editing
            { plugin = vp.comment-nvim; type = "lua"; config = "require('Comment').setup()"; }
            { plugin = vp.refactoring-nvim; type = "lua"; config = builtins.readFile ./plugin/refactoring.lua; }
            vp.vim-tmux-navigator

            # UI
            { plugin = vp.heirline-nvim; type = "lua"; config = builtins.readFile ./plugin/statusline.lua; }
            {
              plugin = vp.tokyonight-nvim;
              type = "lua";
              config = ''${builtins.readFile ./plugin/tokyonight.lua}
                pcall(vim.cmd.colorscheme, 'tokyonight-storm')
              '';
            }
            { plugin = vp.trouble-nvim; type = "lua"; config = "require('trouble').setup()"; }
            { plugin = vp.zen-mode-nvim; type = "lua"; config = "require('zen-mode').setup()"; }

            # Completion
            { plugin = vp.nvim-cmp; type = "lua"; config = builtins.readFile ./plugin/cmp.lua; }
            vp.cmp-nvim-lsp-signature-help

            # Telescope
            { plugin = vp.telescope-nvim; type = "lua"; config = builtins.readFile ./plugin/telescope.lua; }

            # DAP
            { plugin = vp.nvim-dap; type = "lua"; config = builtins.readFile ./plugin/dap.lua; }
          ]
          ++ languageDapPlugins
          ++ languagePlugins
          ++ lib.optionals (builtins.hasAttr "typescript" enabledLanguages) [{
            plugin = vp.nvim-dap-vscode-js;
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
          ++ cfg.extraPlugins;

        extraLuaConfig = lib.concatStrings [
          (builtins.readFile ./options.lua)
          (builtins.readFile ./autocmds.lua)
          (builtins.readFile ./keymaps.lua)
          cfg.extraLuaConfig
        ];
      };
    };
}
