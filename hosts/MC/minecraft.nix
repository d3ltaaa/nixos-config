{ inputs, pkgs, ... }: # Make sure the flake inputs are in your system's config
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    # main server
    servers.S05-fabric = {
      enable = true;
      operators = {
        deltaaaaaa = {
          uuid = "282a6b60-251c-4bec-9c84-24ec054d7e63";
          level = 4; # 4 is the max permission level
          bypassesPlayerLimit = true;
        };
      };
      serverProperties = {
        whitelist = false;
        server-port = 43000;
        difficulty = "hard";
        level-seed = "17862807";
        jvmOpts = "-Xms2G -Xmx8G";
        spawn-protection = 0;
      };

      # Specify the custom minecraft server package
      package = pkgs.fabricServers.fabric-1_21_10;

      symlinks = {
      };
    };
    # test server
    servers.S07-fabric = {
      enable = false;
      operators = {
        deltaaaaaa = {
          uuid = "282a6b60-251c-4bec-9c84-24ec054d7e63";
          level = 4; # 4 is the max permission level
          bypassesPlayerLimit = true;
        };
      };

      serverProperties = {
        whitelist = false;
        server-port = 43001;
        difficulty = "hard";
      };

      # Specify the custom minecraft server package
      package = pkgs.fabricServers.fabric-1_21_10;

      symlinks = {
      };
    };
  };
}
