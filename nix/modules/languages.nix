{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    elixir
    gcc
    go 
    rustup
    gofumpt
    golines
    goimports-reviser
    tailwindcss
    tailwindcss-language-server
  ];
}
