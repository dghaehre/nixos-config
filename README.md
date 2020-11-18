# My nixos config

Setup:

```
git clone https://github.com/dghaehre/nixos-config.git
cd nixos-config
mv /etc/nixos/configuration.nix /etc/nixos/configuration.bak
ln -s ./configuration.nix /etc/nixos/configuration.nix
nixos-rebuild switch
```
