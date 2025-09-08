{
  # Common environment variables shared across hosts
  commonEnvironment = {
    EDITOR = "nvim";
    TERM = "xterm-256color";
  };

  # macOS specific environment additions
  darwinEnvironment = {
    SHELL = "zsh"; # This will be resolved to the actual zsh path by the Darwin config
  };

  # Function to merge environments
  mkEnvironment = { isDarwin ? false }: 
    commonEnvironment // (if isDarwin then darwinEnvironment else {});
}