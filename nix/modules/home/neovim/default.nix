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
  };

  config = mkIf cfg.enable {
    programs.neovim = {
        enable = true;

        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        extraPackages = with pkgs;
          let
            phpCsFixer =
              if pkgs ? php83Packages then pkgs.php83Packages.php-cs-fixer
              else if pkgs ? php82Packages then pkgs.php82Packages.php-cs-fixer
              else null;
            pyrightPkg =
              if nodePackages ? pyright then nodePackages.pyright
              else if pkgs ? pyright then pkgs.pyright
              else null;
            ruffPkg =
              if python3Packages ? ruff then python3Packages.ruff
              else if pkgs ? ruff then pkgs.ruff
              else null;
          in
          [
            lua-language-server
            ripgrep
            omnisharp-roslyn
            stylua
            unzip
            nodejs

            nil # Language server per Nix
            nixpkgs-fmt # Formattatore per Nix

            sleek # Formattatore

            # LSPs and tools used by config
            gopls
            nodePackages.typescript
            nodePackages.typescript-language-server
            nodePackages.ts-node
            nodePackages.intelephense

            # DAP tools
            delve
            python3
            python3Packages.debugpy

            # Python formatters
            python3Packages.black
            python3Packages.isort
          ]
          ++ lib.optionals (phpCsFixer != null) [ phpCsFixer ]
          ++ lib.optionals (pyrightPkg != null) [ pyrightPkg ]
          ++ lib.optionals (ruffPkg != null) [ ruffPkg ]
          ++ lib.optionals stdenv.isLinux [ xclip wl-clipboard netcoredbg ]
          ++ lib.optionals stdenv.isDarwin [ reattach-to-user-namespace ]
          ++ lib.optionals (pkgs.nodePackages ? blade-formatter) [ nodePackages.blade-formatter ];
        plugins = with pkgs.vimPlugins;
          let
            jsDebugPath =
              if (builtins.hasAttr "vscode-extensions" pkgs)
              && (builtins.hasAttr "ms-vscode" pkgs.vscode-extensions)
              && (builtins.hasAttr "js-debug" pkgs.vscode-extensions."ms-vscode")
              then "${pkgs.vscode-extensions."ms-vscode"."js-debug"}/share/vscode/extensions/ms-vscode.js-debug"
              else "";
          in [
          undotree
          cmp-nvim-lsp
          cmp-path
          cmp-buffer

          cmp_luasnip

          lspkind-nvim

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
              p.tree-sitter-python
              p.tree-sitter-markdown
              p.tree-sitter-markdown_inline
            ]);
            type = "lua";
            config = builtins.readFile ./plugin/treesitter.lua;
          }
          {
            plugin = oil-nvim;
            type = "lua";
            config = builtins.readFile ./plugin/oil.lua;
          }
          {
            plugin = nvim-lspconfig;
            type = "lua";
            config = builtins.readFile ./plugin/lsp.lua;
          }
          {
            plugin = comment-nvim;
            type = "lua";
            config = "require('Comment').setup()";
          }
          {
            plugin = lualine-nvim;
            type = "lua";
            config = builtins.readFile ./plugin/lualine.lua;
          }
          {
            plugin = tokyonight-nvim;
            type = "lua";
            config = ''vim.cmd.colorscheme('tokyonight-storm')'';
          }
          {
            plugin = nvim-cmp;
            type = "lua";
            config = builtins.readFile ./plugin/cmp.lua;
          }
          {
            plugin = telescope-nvim;
            type = "lua";
            config = builtins.readFile ./plugin/telescope.lua;
          }
          {
            plugin = nvim-dap;
            type = "lua";
            config = builtins.readFile ./plugin/dap.lua;
          }
          {
            plugin = nvim-dap-vscode-js;
            type = "lua";
            config = ''
              local ok, js = pcall(require, "dap-vscode-js")
              if ok then
                local debugger_path = "${jsDebugPath}"
                if debugger_path ~= "" then
                  js.setup({
                    debugger_path = debugger_path,
                    adapters = { 'pwa-node', 'pwa-chrome', 'pwa-extensionHost', 'node-terminal' },
                  })
                end
              end
            '';
          }
          nvim-dap-python
          {
            plugin = refactoring-nvim;
            type = "lua";
            config = builtins.readFile ./plugin/refactoring.lua;
          }
          vim-tmux-navigator
          {
            plugin = trouble-nvim;
            type = "lua";
            config = "require('trouble').setup()";
          }
          {
            plugin = zen-mode-nvim;
            type = "lua";
            config = "require('zen-mode').setup()";
          }
          copilot-cmp
          {
            plugin = copilot-lua;
            type = "lua";
            config = builtins.readFile ./plugin/copilot.lua;
          }
        ];

        extraLuaConfig = builtins.readFile ./options.lua;
      };
  };
}
