{ lib, config, pkgs, inputs, ... }:

  with lib;
    let
    cfg = config.neovim;
  in
  {
  options = {
    neovim.enable 
      = mkEnableOption "enable neovim module";
  };

  config = mkIf cfg.enable {
    programs.neovim = 
      let
        toLua = str: "lua << EOF\n${str}\nEOF\n";
        toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
      in
        {
        enable = true;

        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        extraPackages = with pkgs; [
          lua-language-server
          gopls
          xclip
          wl-clipboard
          ripgrep
          omnisharp-roslyn
          delve
          stylua
          unzip
        ];

        plugins = with pkgs.vimPlugins; [

          cmp-nvim-lsp
          cmp-path
          cmp-buffer

          cmp_luasnip
          cmp-nvim-lsp

          lspkind-nvim

          nvim-cmp 
          lualine-nvim
          nvim-web-devicons
          telescope-fzf-native-nvim
          plenary-nvim
          vim-nix
          nvim-dap-go
          nvim-dap-ui
          nvim-dap-virtual-text
          nvim-nio
          mason-nvim
          mason-lspconfig-nvim
          mason-tool-installer-nvim
          fidget-nvim
          conform-nvim
          obsidian-nvim
          neodev-nvim
          SchemaStore-nvim
          lsp_lines-nvim
          luasnip
          friendly-snippets
          copilot-lua
          copilot-cmp
          {
            plugin = (nvim-treesitter.withPlugins (p: [
              p.tree-sitter-nix
              p.tree-sitter-vim
              p.tree-sitter-lua
              p.tree-sitter-json
              p.tree-sitter-c_sharp
              p.tree-sitter-go
              p.tree-sitter-markdown
              p.tree-sitter-markdown_inline
            ]));
            config = toLuaFile ./plugin/treesitter.lua;
          }
          {
            plugin = oil-nvim;
            config = toLuaFile ./plugin/oil.lua;
          }
          {
            plugin = nvim-lspconfig;
            config = toLuaFile ./plugin/lsp.lua;
          }

          {
            plugin = comment-nvim;
            config = toLua "require(\"Comment\").setup()";
          }

          {
            plugin = tokyonight-nvim;
            config = "colorscheme tokyonight-storm";
          }

          {
            plugin = nvim-cmp;
            config = toLuaFile ./plugin/cmp.lua;
          }

          {
            plugin = telescope-nvim;
            config = toLuaFile ./plugin/telescope.lua;
          }
          {
            plugin = harpoon2;
            config = toLuaFile ./plugin/harpoon.lua;
          }

          {
            plugin = vim-fugitive;
            config = toLuaFile ./plugin/fugitive.lua;
          }

          {
            plugin = nvim-dap;
            config = toLuaFile ./plugin/dap.lua;
          }
          {
            plugin = refactoring-nvim;
            config = toLuaFile ./plugin/refactoring.lua;
          }
          {
            plugin = vim-tmux-navigator;
            config = toLuaFile ./plugin/tmux.lua;
          }
          {
            plugin = trouble-nvim;
            config = toLuaFile ./plugin/trouble.lua;
          }
          {
            plugin = undotree;
            config = toLuaFile ./plugin/undotree.lua;
          }
          {
            plugin = zen-mode-nvim;
            config = toLuaFile ./plugin/zen.lua;
          }
        ];

        extraLuaConfig = ''

          ${builtins.readFile ./options.lua}
        '';
      };
    home.packages = with pkgs; [
      nodejs_23
    ];
  };
}
