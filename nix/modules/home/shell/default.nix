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

        PROMPT='%F{blue}%~%f ''${vcs_info_msg_0_:+ $vcs_info_msg_0_}
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
          src = pkgs.zsh-fzf-tab;
        }
      ];
    };

    home.packages = [
      pkgs.jq
      pkgs.jqp
      pkgs.httpie
      pkgs.ripgrep
      pkgs.tree
      pkgs.gh
    ];
  };
}
