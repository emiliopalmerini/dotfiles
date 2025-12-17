{
  imports = [
    # Core system configuration
    ./basic-system
    ./mainUser
    ./home-manager-integration

    # Localization and input
    ./italian-locale
    ./input-method

    # Desktop environments
    ./gnome-desktop
    ./hyprland

    # Networking and remote access
    ./tailscale
    ./tailscale-only-access

    # Services and applications
    ./docker
    ./clamav
    ./media-server

    # Virtualization
    ./vm
  ];
}
