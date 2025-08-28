{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configurations.server.litellm = {
      enable = lib.mkEnableOption "Enables litellm module";
    };
  };

  config =
    let
      cfg = config.applications.configurations.server.litellm;
    in
    lib.mkIf cfg.enable {
      services.postgresql = {
        enable = true;
        # ensureDatabases = [ "mydatabase" ];
        enableTCPIP = true;
        # port = 5432;
        authentication = pkgs.lib.mkOverride 10 ''
          #...
          #type database DBuser origin-address auth-method
          local all       all     trust
          # ipv4
          host  all      all     127.0.0.1/32   trust
          # ipv6
          host all       all     ::1/128        trust
        '';
        initialScript = pkgs.writeText "init-nixcloud" ''
          -- create the role
          CREATE ROLE nixcloud WITH
            LOGIN
            PASSWORD 'nixcloud'
            CREATEDB;

          -- create the database and make nixcloud its owner
          CREATE DATABASE nixcloud OWNER nixcloud;

          -- connect into nixcloud and ensure the public schema is owned by nixcloud
          \connect nixcloud
          ALTER SCHEMA public OWNER TO nixcloud;
          GRANT ALL PRIVILEGES ON SCHEMA public TO nixcloud;
        '';
        # initialScript = pkgs.writeText "backend-initScript" ''
        #   CREATE ROLE nixcloud WITH LOGIN PASSWORD 'nixcloud' CREATEDB;
        #   CREATE DATABASE nixcloud;
        #   GRANT ALL PRIVILEGES ON DATABASE nixcloud TO nixcloud;
        # '';
      };

      networking.firewall.allowedTCPPorts = [ 8090 ];
      virtualisation = {
        podman.enable = true;
        oci-containers.containers.litellm = {
          image = "litellm/litellm:v1.75.8-stable"; # Update
          autoStart = true;
          extraOptions = [
            "--network=host"
            "--pull=newer"
          ];
          entrypoint = "/usr/bin/litellm";
          cmd = [
            "--port"
            "8090"
            "--host"
            "0.0.0.0"
          ];
          volumes = [
            "/var/lib/litellm:/var/lib/litellm"
          ];
          environment = {
            LITELLM_MASTER_KEY = "sk-1234";
            DATABASE_URL = "postgres://nixcloud:nixcloud@127.0.0.1:5432/nixcloud";
            STORE_MODEL_IN_DB = "True";
            HOME = "/var/lib/litellm";
            XDG_CACHE_HOME = "/var/lib/litellm/.cache";
          };
        };
      };
    };
}
