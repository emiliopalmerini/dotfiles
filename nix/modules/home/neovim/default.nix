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

  vp = pkgs.vimPlugins;

  # Helper to create plugin specs with optional lazy-loading support
  # When optional = true, plugin is available but not auto-loaded (packadd required)
  mkPlugin = { plugin, config ? null, optional ? false }:
    if config != null then
      { inherit plugin optional; type = "lua"; config = config; }
    else
      { inherit plugin optional; };

  # Core plugins - loaded immediately (essential for startup)
  corePlugins = [
    vp.plenary-nvim
    vp.nvim-web-devicons
    { plugin = vp.tokyonight-nvim; type = "lua"; config = ''
        ${builtins.readFile ./plugin/tokyonight.lua}
        pcall(vim.cmd.colorscheme, 'tokyonight-storm')
      '';
    }
  ];

  # Completion plugins - needed early for insert mode
  completionPlugins = [
    vp.cmp-nvim-lsp
    vp.cmp-path
    vp.cmp-buffer
    vp.cmp_luasnip
    vp.lspkind-nvim
    vp.luasnip
    vp.friendly-snippets
    vp.cmp-nvim-lsp-signature-help
    (mkPlugin { plugin = vp.nvim-cmp; config = builtins.readFile ./plugin/cmp.lua; })
  ];

  # LSP plugins - loaded on BufReadPre
  lspPlugins = [
    vp.neodev-nvim
    vp.SchemaStore-nvim
    (mkPlugin {
      plugin = vp.nvim-lspconfig;
      config = ''
        local language_servers = ${generateLspServersLua languageLspConfigs}
        ${builtins.readFile ./plugin/lsp.lua}
      '';
    })
    (mkPlugin { plugin = vp.conform-nvim; config = builtins.readFile ./plugin/conform.lua; })
    (mkPlugin { plugin = vp.fidget-nvim; config = "require('fidget').setup({})"; })
  ];

  # Treesitter plugins - needed for highlighting
  treesitterPlugins = [
    (mkPlugin {
      plugin = vp.nvim-treesitter.withPlugins languageTreesitterGrammars;
      config = builtins.readFile ./plugin/treesitter.lua;
    })
    vp.nvim-treesitter-textobjects
  ];

  # Telescope plugins - loaded on command
  telescopePlugins = [
    vp.telescope-fzf-native-nvim
    (mkPlugin { plugin = vp.telescope-nvim; config = builtins.readFile ./plugin/telescope.lua; })
  ];

  # Git plugins - gitsigns needed for buffer signs
  gitPlugins = [
    vp.vim-fugitive
    (mkPlugin { plugin = vp.gitsigns-nvim; config = builtins.readFile ./plugin/gitsigns.lua; })
  ];

  # DAP plugins - LAZY: loaded on first debug command via keymaps.lua
  # Uses require("dap") which triggers plugin loading
  dapPlugins = [
    (mkPlugin { plugin = vp.nvim-dap-ui; optional = true; })
    (mkPlugin { plugin = vp.nvim-dap-virtual-text; optional = true; })
    (mkPlugin { plugin = vp.nvim-nio; optional = true; })
    (mkPlugin { plugin = vp.nvim-dap; optional = true; config = builtins.readFile ./plugin/dap.lua; })
  ];

  # UI plugins - which-key and statusline needed at startup
  uiPlugins = [
    (mkPlugin { plugin = vp.which-key-nvim; config = builtins.readFile ./plugin/which-key.lua; })
    (mkPlugin { plugin = vp.heirline-nvim; config = builtins.readFile ./plugin/statusline.lua; })
    # LAZY: Trouble loaded on :Trouble command
    (mkPlugin { plugin = vp.trouble-nvim; optional = true; config = "require('trouble').setup()"; })
    (mkPlugin { plugin = vp.todo-comments-nvim; config = "require('todo-comments').setup()"; })
  ];

  # Editing plugins
  editingPlugins = [
    vp.undotree
    vp.harpoon2
    vp.vim-tmux-navigator
    vp.vim-nix
    (mkPlugin { plugin = vp.comment-nvim; config = "require('Comment').setup()"; })
    # LAZY: Refactoring loaded on first use via keymaps.lua
    (mkPlugin { plugin = vp.refactoring-nvim; optional = true; config = builtins.readFile ./plugin/refactoring.lua; })
    # LAZY: Zen-mode loaded on first use via keymaps.lua
    (mkPlugin { plugin = vp.zen-mode-nvim; optional = true; config = "require('zen-mode').setup()"; })
  ];

  # File navigation plugins
  navigationPlugins = [
    (mkPlugin { plugin = vp.oil-nvim; config = builtins.readFile ./plugin/oil.lua; })
    # LAZY: Obsidian loaded on markdown files
    (mkPlugin { plugin = vp.obsidian-nvim; optional = true; config = builtins.readFile ./plugin/obsidian.lua; })
  ];

  # TypeScript DAP (conditional)
  jsDebugPath =
    if (builtins.hasAttr "vscode-extensions" pkgs)
      && (builtins.hasAttr "ms-vscode" pkgs.vscode-extensions)
      && (builtins.hasAttr "js-debug" pkgs.vscode-extensions."ms-vscode")
    then "${pkgs.vscode-extensions."ms-vscode"."js-debug"}/share/vscode/extensions/ms-vscode.js-debug"
    else "";

  typescriptDapPlugins = lib.optionals (builtins.hasAttr "typescript" enabledLanguages) [{
    plugin = vp.nvim-dap-vscode-js;
    optional = true;
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
  }];

in
{
  options = {
    neovim.enable = mkEnableOption "enable neovim module";

    neovim.extraPlugins = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Additional Vim plugins to load.";
    };

    neovim.extraLuaConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra Lua appended to module config.";
    };
  };

  config = mkIf cfg.enable {
    # Copy lua/plugins directory to ~/.config/nvim/lua/plugins
    # lazy.nvim will find them there via { import = "plugins" }
    xdg.configFile."nvim/lua/plugins".source = ./lua/plugins;

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
        corePlugins
        ++ completionPlugins
        ++ lspPlugins
        ++ treesitterPlugins
        ++ telescopePlugins
        ++ gitPlugins
        ++ dapPlugins
        ++ uiPlugins
        ++ editingPlugins
        ++ navigationPlugins
        ++ languageDapPlugins
        ++ languagePlugins
        ++ typescriptDapPlugins
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
