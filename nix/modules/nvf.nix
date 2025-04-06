{
  lib,
  config,
  ...
}: {
  #TODO: return to my keymaps for cmp
  #TODO: return to my keymaps for snippets
  #TODO: add highlight
  vim = {
    viAlias = true;
    vimAlias = true;
    spellcheck = {
      enable = false;
    };

    lsp = {
      formatOnSave = true;
      lspkind.enable = true;
      lightbulb.enable = false;
      lspsaga.enable = false;
      trouble.enable = true;
      lspSignature.enable = true;
      otter-nvim.enable = true;
      lsplines.enable = true;
      nvim-docs-view.enable = false;
    };

    debugger = {
      nvim-dap = {
        enable = true;
        ui.enable = true;
      };
    };

    # This section does not include a comprehensive list of available language modules.
    # To list all available language module options, please visit the nvf manual.
    languages = {
      enableLSP = true;
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      # Languages that will be supported in default and maximal configurations.
      nix.enable = true;
      markdown.enable = true;

      # Languages that are enabled in the maximal configuration.
      bash.enable = true;
      clang.enable = false;
      css.enable = true;
      html.enable = true;
      sql.enable = true;
      java.enable = false;
      kotlin.enable = false;
      ts.enable = true;
      go.enable = true;
      lua.enable = true;
      zig.enable = false;
      python.enable = true;
      typst.enable = false;
      rust = {
        enable = false;
        crates.enable = false;
      };

      # Language modules that are not as common.
      assembly.enable = false;
      astro.enable = false;
      nu.enable = false;
      csharp.enable = true;
      julia.enable = false;
      vala.enable = false;
      scala.enable = false;
      r.enable = false;
      gleam.enable = false;
      dart.enable = false;
      ocaml.enable = false;
      elixir.enable = false;
      haskell.enable = false;
      ruby.enable = false;
      fsharp.enable = false;

      tailwind.enable = true;
      svelte.enable = false;

      # Nim LSP is broken on Darwin and therefore
      # should be disabled by default. Users may still enable
      # `vim.languages.vim` to enable it, this does not restrict
      # that.
      # See: <https://github.com/PMunch/nimlsp/issues/178#issue-2128106096>
      nim.enable = false;
    };

    visuals = {
      nvim-scrollbar.enable = false;
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      cinnamon-nvim.enable = false;
      fidget-nvim.enable = true;

      highlight-undo.enable = true;
      indent-blankline.enable = false;

      # Fun
      cellular-automaton.enable = false;
    };

    statusline = {
      lualine = {
        enable = true;
        theme = "tokyonight";
      };
    };

    theme = {
      enable = true;
      name = "tokyonight";
      style = "storm";
      transparent = false;
    };

    autopairs.nvim-autopairs.enable = false;

    autocomplete = {
      nvim-cmp = {
        enable = true;
        # mappings = {
        #   previous = "C-p";
        #   next = "C-n";
        #   confirm = "C-y";
        # };
      };
    };
    snippets.luasnip.enable = true;

    filetree = {
      neo-tree = {
        enable = false;
      };
    };

    tabline = {
      nvimBufferline.enable = false;
    };

    treesitter.context.enable = true;

    binds = {
      whichKey.enable = true;
      cheatsheet.enable = true;
    };

    telescope.enable = true;

    git = {
      enable = true;
      gitsigns.enable = true;
      gitsigns.codeActions.enable = false; # throws an annoying debug message
    };

    minimap = {
      minimap-vim.enable = false;
      codewindow.enable = false; # lighter, faster, and uses lua for configuration
    };

    dashboard = {
      dashboard-nvim.enable = true;
      alpha.enable = true;
    };

    notify = {
      nvim-notify.enable = false;
    };

    projects = {
      project-nvim.enable = true;
    };

    utility = {
      ccc.enable = false;
      vim-wakatime.enable = false;
      diffview-nvim.enable = true;
      yanky-nvim.enable = false;
      icon-picker.enable = false;
      surround.enable = false;
      leetcode-nvim.enable = false;
      multicursors.enable = false;
      oil-nvim.enable = true;

      motion = {
        hop.enable = false;
        leap.enable = false;
        precognition.enable = false;
      };
      images = {
        image-nvim.enable = false;
      };
    };

    notes = {
      obsidian.enable = false; # FIXME: neovim fails to build if obsidian is enabled
      neorg.enable = false;
      orgmode.enable = false;
      mind-nvim.enable = false;
      todo-comments.enable = true;
    };

    terminal = {
      toggleterm = {
        enable = true;
        lazygit.enable = true;
      };
    };

    ui = {
      borders.enable = true;
      noice.enable = true;
      colorizer.enable = true;
      modes-nvim.enable = false; # the theme looks terrible with catppuccin
      illuminate.enable = true;
      breadcrumbs = {
        enable = false;
        navbuddy.enable = false;
      };
      smartcolumn = {
        enable = true;
        setupOpts.custom_colorcolumn = {
          nix = "110";
          ruby = "120";
          java = "130";
          go = ["90" "130"];
        };
      };
      fastaction.enable = true;
    };

    assistant = {
      chatgpt.enable = false;
      copilot = {
        enable = false;
        cmp.enable = false;
      };
      codecompanion-nvim.enable = false;
    };

    session = {
      nvim-session-manager.enable = false;
    };

    gestures = {
      gesture-nvim.enable = false;
    };

    comments = {
      comment-nvim.enable = true;
    };

    presence = {
      neocord.enable = false;
    };

    augroups = [
      # {
      #   enable = true;
      #   name = "highlight-yank";
      #   clear = true;
      # }
    ];

    # autocmds = [
    #   {
    #     enable = true;
    #     desc = "Highlight when yanking (copying) text";
    #     group = "highlight-yank";
    #     callback = lib.generators.mkLuaInline ''
    #       function()
    #           vim.highlight.on_yank()
    #       end
    #     '';
    #   }
    # ];

    keymaps = [
      {
        mode = "n";
        key = "<leader>-";
        action = "<CMD>Oil<CR>";
      }
      {
        mode = "n";
        key = "<leader>-f";
        action = "<CMD>Oil --float<CR>";
      }
      {
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
      }
      {
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
      }
      {
        mode = "n";
        key = "J";
        action = "mzJ`z";
      }
      {
        mode = "n";
        key = "<C-d>";
        action = "<C-d>zz";
      }
      {
        mode = "n";
        key = "<C-u>";
        action = "<C-u>zz";
      }
      {
        mode = "n";
        key = "n";
        action = "nzzzv";
      }
      {
        mode = "n";
        key = "N";
        action = "Nzzzv";
      }
      {
        mode = "x";
        key = "<leader>p";
        action = ''[["_dP]]'';
      }
      {
        mode = ["n" "v"];
        key = "<leader>y";
        action = ''[["+y]]'';
      }
      {
        mode = "n";
        key = "<leader>Y";
        action = ''[["+Y]]'';
      }
      {
        mode = "n";
        key = "Q";
        action = "<nop>";
      }
      {
        mode = "n";
        key = "[N";
        action = "<cmd>cnext<CR>zz";
      }
      {
        mode = "n";
        key = "]J";
        action = "<cmd>cprev<CR>zz";
      }
      {
        mode = "n";
        key = "<leader>k";
        action = "<cmd>lnext<CR>zz";
      }
      {
        mode = "n";
        key = "<leader>j";
        action = "<cmd>lprev<CR>zz";
      }
      {
        mode = "n";
        key = "<left>";
        action = "<c-w>5<";
      }
      {
        mode = "n";
        key = "<right>";
        action = "<c-w>5>";
      }
      {
        mode = "n";
        key = "<up>";
        action = "<C-W>+";
      }
      {
        mode = "n";
        key = "<down>";
        action = "<C-W>-";
      }
    ];
  };
}
