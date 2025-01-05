{ lib, config, pkgs, inputs, ... }:

{
  options = {
    neovim.enable 
      = lib.mkEnableOption "enable neovim module";
  };

  config = lib.mkIf config.neovim.enable {
    nixpkgs = {
      overlays = [
        (final: prev: {
          vimPlugins = prev.vimPlugins // {
            own-harpoon-nvim = prev.vimUtils.buildVimPlugin {
              name = "harpoon";
              version = "harpoon2";
              src = inputs.plugin-harpoon;
            };
          };
        })
      ];
    };

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
        ];

        plugins = with pkgs.vimPlugins; [

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

          nvim-cmp 
          {
            plugin = nvim-cmp;
            config = toLuaFile ./plugin/cmp.lua;
          }

          telescope-fzf-native-nvim
          {
            plugin = telescope-nvim;
            config = toLuaFile ./plugin/telescope.lua;
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
            config = toLuaFile ./plugin/treesitter.lua;
          }

          plenary-nvim
          {
            plugin = own-harpoon-nvim;
            config = toLuaFile ./plugin/harpoon.lua;
          }

          vim-nix
          {
            plugin = vim-fugitive;
          }
        ];

        extraLuaConfig = ''

          ${builtins.readFile ./options.lua}
        '';
      };
  };
}
