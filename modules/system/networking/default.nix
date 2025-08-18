{ ... }:
{
  import = [
    ./server/default.nix
    ./bridgedNetwork.nix
    ./firewall.nix
    ./general.nix
    ./wakeOnLan.nix
  ];
}
