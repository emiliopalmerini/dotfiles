{
  imports = [
    # Existing modules
    ./docker
    ./clamav
    ./mainUser
    ./tailscale

    # New shared modules
    ./basic-system
    ./gnome-desktop
    ./home-manager-integration
    ./italian-locale
    ./media-server
    ./tailscale-only-access
    ./vm
  ];
}
