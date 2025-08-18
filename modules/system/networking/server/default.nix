{ ... }:
{
  import = [
    ./acme.nix
    ./dnsmasq.nix
    ./nginx.nix
    ./wireguard.nix
  ];
}
