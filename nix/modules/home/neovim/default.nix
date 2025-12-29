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

  # All plugins that will be managed by lazy.nvim
  # We still use Nix to provide them, lazy.nvim just handles loading
  allPlugins = {
    # Core (loaded immediately)
    "plenary.nvim" = vp.plenary-nvim;
    "nvim-web-devicons" = vp.nvim-web-devicons;
    "tokyonight.nvim" = vp.tokyonight-nvim;

    # Completion
    "nvim-cmp" = vp.nvim-cmp;
    "cmp-nvim-lsp" = vp.cmp-nvim-lsp;
    "cmp-path" = vp.cmp-path;
    "cmp-buffer" = vp.cmp-buffer;
    "cmp_luasnip" = vp.cmp_luasnip;
    "lspkind.nvim" = vp.lspkind-nvim;
    "LuaSnip" = vp.luasnip;
    "friendly-snippets" = vp.friendly-snippets;
    "cmp-nvim-lsp-signature-help" = vp.cmp-nvim-lsp-signature-help;

    # LSP
    "nvim-lspconfig" = vp.nvim-lspconfig;
    "neodev.nvim" = vp.neodev-nvim;
    "SchemaStore.nvim" = vp.SchemaStore-nvim;
    "conform.nvim" = vp.conform-nvim;
    "fidget.nvim" = vp.fidget-nvim;
    "roslyn.nvim" = vp.roslyn-nvim;

    # Treesitter
    "nvim-treesitter" = vp.nvim-treesitter.withPlugins languageTreesitterGrammars;
    "nvim-treesitter-textobjects" = vp.nvim-treesitter-textobjects;

    # Telescope
    "telescope.nvim" = vp.telescope-nvim;
    "telescope-fzf-native.nvim" = vp.telescope-fzf-native-nvim;

    # Git
    "vim-fugitive" = vp.vim-fugitive;
    "gitsigns.nvim" = vp.gitsigns-nvim;

    # DAP
    "nvim-dap" = vp.nvim-dap;
    "nvim-dap-ui" = vp.nvim-dap-ui;
    "nvim-dap-virtual-text" = vp.nvim-dap-virtual-text;
    "nvim-nio" = vp.nvim-nio;
    "nvim-dap-go" = vp.nvim-dap-go;

    # UI
    "which-key.nvim" = vp.which-key-nvim;
    "heirline.nvim" = vp.heirline-nvim;
    "trouble.nvim" = vp.trouble-nvim;
    "todo-comments.nvim" = vp.todo-comments-nvim;

    # Editing
    "undotree" = vp.undotree;
    "harpoon" = vp.harpoon2;
    "vim-tmux-navigator" = vp.vim-tmux-navigator;
    "vim-nix" = vp.vim-nix;
    "Comment.nvim" = vp.comment-nvim;
    "refactoring.nvim" = vp.refactoring-nvim;
    "zen-mode.nvim" = vp.zen-mode-nvim;

    # Navigation
    "oil.nvim" = vp.oil-nvim;
    "obsidian.nvim" = vp.obsidian-nvim;

    # lazy.nvim itself
    "lazy.nvim" = vp.lazy-nvim;
  };

  # Generate Lua table mapping plugin names to Nix store paths
  pluginPathsLua =
    let
      entries = lib.mapAttrsToList (name: pkg: ''["${name}"] = "${pkg}"'') allPlugins;
    in
    "{\n  ${lib.concatStringsSep ",\n  " entries}\n}";

  # TypeScript DAP path (conditional)
  jsDebugPath =
    if (builtins.hasAttr "vscode-extensions" pkgs)
      && (builtins.hasAttr "ms-vscode" pkgs.vscode-extensions)
      && (builtins.hasAttr "js-debug" pkgs.vscode-extensions."ms-vscode")
    then "${pkgs.vscode-extensions."ms-vscode"."js-debug"}/share/vscode/extensions/ms-vscode.js-debug"
    else "";

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

      # We still provide plugins via Nix, but lazy.nvim manages loading
      plugins = lib.attrValues allPlugins ++ languageDapPlugins ++ languagePlugins ++ cfg.extraPlugins;

      extraLuaConfig = ''
        -- Plugin paths from Nix store (global for plugin specs)
        local nix_plugins = ${pluginPathsLua}
        _G.plugin_path = function(name)
          return nix_plugins[name]
        end

        -- LSP server configs from Nix (global for lsp.lua)
        _G.language_servers = ${generateLspServersLua languageLspConfigs}

        -- JS Debug path for DAP (global for dap.lua)
        _G.js_debug_path = "${jsDebugPath}"

        -- Bootstrap lazy.nvim from Nix store
        local lazypath = _G.plugin_path("lazy.nvim")
        vim.opt.rtp:prepend(lazypath)

        -- Load options first (before plugins)
        ${builtins.readFile ./options.lua}

        -- Load lazy.nvim with plugin specs
        require("lazy").setup({
          spec = {
            { import = "plugins" },
          },
          defaults = {
            lazy = true,  -- Lazy load by default
          },
          performance = {
            reset_packpath = false,  -- Keep Nix plugins in packpath
            rtp = {
              reset = false,  -- Don't reset runtimepath
            },
          },
          install = {
            missing = false,  -- Don't try to install - Nix provides everything
          },
          change_detection = {
            enabled = false,  -- Nix handles plugin updates
          },
          rocks = {
            enabled = false,  -- Nix provides everything, no luarocks needed
          },
        })

        -- Load autocmds and keymaps after plugins
        ${builtins.readFile ./autocmds.lua}
        ${builtins.readFile ./keymaps.lua}

        ${cfg.extraLuaConfig}
      '';
    };
  };
}
