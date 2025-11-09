{ lib, config, ... }:
{
  options = {
    applications.configurations.server.searx = {
      enable = lib.mkEnableOption "Enables searx module";
    };
  };

  config =
    let
      cfg = config.applications.configurations.server.searx;
    in
    lib.mkIf cfg.enable {
      services.searx = {
        enable = true;
        redisCreateLocally = true;
        settings = {
          server = {
            port = 8081;
            secret_key = config.secrets.searxSecret;
          };
          search = {
            formats = [
              "json"
              "html"
            ];
          };
        };
      };
    };

}
