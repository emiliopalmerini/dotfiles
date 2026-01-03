{ lib
, config
, pkgs
, ...
}:
with lib; let
  cfg = config.shell;
  myAliases = {
    cat = "bat";
  };
  zshColors = "\${(s.:.)LS_COLORS}";
in
{
  options.shell = {
    enable = mkEnableOption "enable zsh module";
  };

  config = mkIf cfg.enable {
    programs.bat.enable = true;
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = myAliases;

      initContent = lib.optionalString pkgs.stdenv.isDarwin ''
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
      '' + ''
        HISTDUP=erase

        setopt HIST_FIND_NO_DUPS
        setopt HIST_IGNORE_SPACE
        setopt HIST_IGNORE_ALL_DUPS
        setopt HIST_IGNORE_DUPS
        setopt NO_BEEP
        setopt PROMPT_SUBST

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' menu no
        zstyle ':completion:*' list-colors "${zshColors}"
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

        bindkey -e
        bindkey '^Y' yank
        bindkey '^p' history-search-backward
        bindkey '^n' history-search-forward

        # Simple prompt: path, git branch, prompt char
        autoload -Uz vcs_info
        precmd() { vcs_info }
        zstyle ':vcs_info:git:*' formats '%F{242}%b%f'

        PROMPT='%F{green}%n@%m%f %F{blue}%~%f ''${vcs_info_msg_0_:+ $vcs_info_msg_0_}
%(?.%F{magenta}.%F{red})❯%f '

        # kubectl completion
        if command -v kubectl &> /dev/null; then
          source <(kubectl completion zsh)
          compdef _kubectl kubectl
        fi
      '';

      plugins = [
        {
          name = "fzf-tab";
          src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
          file = "fzf-tab.plugin.zsh";
        }
        {
          name = "nix-zsh-completions";
          src = "${pkgs.nix-zsh-completions}/share/zsh/plugins/nix";
          file = "nix-zsh-completions.plugin.zsh";
        }
        {
          name = "zsh-history-substring-search";
          src = "${pkgs.zsh-history-substring-search}/share/zsh/plugins/zsh-history-substring-search";
          file = "zsh-history-substring-search.plugin.zsh";
        }
        {
          name = "zsh-you-should-use";
          src = "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use";
          file = "you-should-use.plugin.zsh";
        }
        {
          name = "zsh-forgit";
          src = "${pkgs.zsh-forgit}/share/zsh/zsh-forgit";
          file = "forgit.plugin.zsh";
        }
        {
          name = "zsh-autopair";
          src = "${pkgs.zsh-autopair}/share/zsh/zsh-autopair";
          file = "autopair.zsh";
        }
      ];
    };

    home.packages = [
      pkgs.jq
      pkgs.jqp
      pkgs.httpie
      pkgs.tree
      pkgs.gh
      pkgs.zsh-completions
    ];
  };
}
