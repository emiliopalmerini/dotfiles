ssh-keygen -t ed25519 -C "your_email@example.com"
git clone {this repo}
sudo cp /etc/nixos/hardware-configuration.nix ./nixos/hosts/{host name} 
sudo nixos-rebuild switch --flake ./nixos#{hostname}
