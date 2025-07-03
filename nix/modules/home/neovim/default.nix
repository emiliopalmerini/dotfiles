{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.neovim;
in {
  options = {
    neovim.enable = mkEnableOption "enable neovim module";
  };

  config = mkIf cfg.enable {
    programs.neovim = let
      toLua = str: "lua << EOF\n${str}\nEOF\n";
      toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    in {
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
        stylua
        unzip
        nodejs

        #nil # Language server per Nix
        nixpkgs-fmt # Formattatore per Nix

        sleek # Formattatore
      ];
      plugins = with pkgs.vimPlugins; [
        undotree
        cmp-nvim-lsp
        cmp-path
        cmp-buffer

        cmp_luasnip
        cmp-nvim-lsp

        lspkind-nvim

        nvim-cmp

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
        neodev-nvim
        SchemaStore-nvim
        lsp_lines-nvim
        luasnip
        friendly-snippets
        harpoon2
        vim-fugitive
        {
          plugin = nvim-treesitter.withPlugins (p: [
            p.tree-sitter-nix
            p.tree-sitter-vim
            p.tree-sitter-lua
            p.tree-sitter-json
            p.tree-sitter-c_sharp
            p.tree-sitter-go
            p.tree-sitter-markdown
            p.tree-sitter-markdown_inline
          ]);
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
          plugin = lualine-nvim;
          config = toLuaFile ./plugin/lualine.lua;
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
          plugin = nvim-dap;
          config = toLuaFile ./plugin/dap.lua;
        }
        {
          plugin = refactoring-nvim;
          config = toLuaFile ./plugin/refactoring.lua;
        }
        vim-tmux-navigator
        {
          plugin = trouble-nvim;
          config = toLua "require('trouble').setup()";
        }
        {
          plugin = zen-mode-nvim;
          config = toLua "require('zen-mode').setup()";
        }
        {
          plugin = obsidian-nvim;
          config = toLuaFile ./plugin/obsidian.lua;
        }
        copilot-cmp
        {
          plugin = copilot-lua;
          config = toLuaFile ./plugin/copilot.lua;
        }
        # {
        #   plugin = supermaven-nvim;
        #   config = toLuaFile ./plugin/supermaven.lua;
        # }
      ];

      extraLuaConfig = ''
        ${builtins.readFile ./options.lua}
      '';
    };
  };
}
