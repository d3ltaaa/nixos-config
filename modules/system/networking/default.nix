{ ... }:
{
  import = [
    ./acme.nix
    ./bridgedNetwork.nix
    ./dnsmasq.nix
    ./firewall.nix
    ./general.nix
    ./nginx.nix
    ./wakeOnLan.nix
    ./wireguard.nix
  ];
}
