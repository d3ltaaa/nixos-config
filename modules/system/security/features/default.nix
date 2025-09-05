{ ... }:
{
  imports = [
    # ./apparmor.nix
    ./backups.nix
    ./bleachBit.nix
    ./clamav.nix
    ./gnupg.nix
    ./fail2ban.nix
    # ./firejail.nix
    # ./opensnitch.nix
    ./passwords.nix
    ./polkit.nix
    ./snapshots.nix
  ];
}
