{ lib, config, pkgs, ... }:

{
  options = {
    neovim.enable 
      = lib.mkEnableOption "enable neovim module";
  };

  config = lib.mkIf config.neovim.enable {
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
        ];

        plugins = with pkgs.vimPlugins; [

          {
            plugin = oil-nvim;
            config = toLuaFile ./nvim/plugin/oil.lua;
          }
          {
            plugin = nvim-lspconfig;
            config = toLuaFile ./nvim/plugin/lsp.lua;
          }

          {
            plugin = comment-nvim;
            config = toLua "require(\"Comment\").setup()";
          }

          {
            plugin = tokyonight-nvim;
            config = "colorscheme tokyonight-storm";
          }

          nvim-cmp 
          {
            plugin = nvim-cmp;
            config = toLuaFile ./nvim/plugin/cmp.lua;
          }

          telescope-fzf-native-nvim
          {
            plugin = telescope-nvim;
            config = toLuaFile ./nvim/plugin/telescope.lua;
          }

          cmp_luasnip
          cmp-nvim-lsp

          luasnip
          friendly-snippets


          lualine-nvim
          nvim-web-devicons

          {
            plugin = (nvim-treesitter.withPlugins (p: [
              p.tree-sitter-nix
              p.tree-sitter-vim
              p.tree-sitter-bash
              p.tree-sitter-lua
              p.tree-sitter-json
            ]));
            config = toLuaFile ./nvim/plugin/treesitter.lua;
          }

          plenary-nvim
          {
            plugin = own-harpoon-nvim;
            config = toLuaFile ./nvim/plugin/harpoon.lua;
          }

          vim-nix
          {
            plugin = vim-fugitive;
          }
        ];

        extraLuaConfig = ''

          ${builtins.readFile ./nvim/options.lua}
        '';
      };
  };
}
