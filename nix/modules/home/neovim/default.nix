{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.neovim;
in
{
  options = {
    neovim.enable = mkEnableOption "enable neovim module";
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
          xclip
          wl-clipboard
          ripgrep
          omnisharp-roslyn
          gopls
          delve
          stylua
          unzip

          # Per supporto Nix
          nil # Language server per Nix
          nixpkgs-fmt # Formattatore per Nix

          # Altri formattatori se necessari
          sleek
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
          fidget-nvim
          conform-nvim
          obsidian-nvim
          neodev-nvim
          SchemaStore-nvim
          lsp_lines-nvim
          luasnip
          friendly-snippets
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
            config = toLua "require('Comment').setup()";
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
          harpoon2
          vim-fugitive
          {
            plugin = nvim-dap;
            config = toLuaFile ./plugin/dap.lua;
          }
          {
            plugin = refactoring-nvim;
            config = toLua "require('refactoring').setup()";
          }
          # {
          #   plugin = vim-tmux-navigator;
          #   config = toLua "require('tmux').setup()";
          # }
          {
            plugin = trouble-nvim;
            config = toLua "require('trouble').setup()";
          }
          undotree
          {
            plugin = zen-mode-nvim;
            config = toLua "require('zen-mode').setup()";
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
